# -*- coding: utf-8 -*-
"""
Created on Wed Apr  8 15:27:12 2020

@author: QC109_1
"""
#%%
import sys
import os, time
import datetime

filename = os.path.abspath(__file__)
dirname = os.path.dirname(filename)
sys.path.append("Q:/Experiment_Scripts/GUI_Control_Program/RemoteEntangle/Sequencer/Sequencer Library")
from SequencerProgram_v1_07 import SequencerProgram, reg
import SequencerUtility_v1_01 as su
from ArtyS7_v1_02 import ArtyS7
import HardwareDefinition_EA as hd

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

import datetime
import socket
import threading
import time
import pickle
import os


detun_freq = 6000  #4090 to compensate for mainaxis stray field
my_dir = 'Q:/Experiment_Scripts/GUI_Control_Program/RemoteEntangle/Sequencer/Sequencer Scripts/data/Rabi/%s_1S/' % datetime.datetime.now().strftime("%y%m%d")
if not os.path.isdir(my_dir):
    os.mkdir(my_dir)
file_name = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
custom_stirng = '_dbm=-9_detun=%.2f_kHz_2.7A_RF_9_dBm' % (detun_freq/1000)

# Input port pin mapping
# input_mapping = {'jb_0': 'PMT','jb_2': 'pulse_trigger', 'ja_2': 'shutter_control'}

# Output port pin mapping
# output_mapping = {'MW': 'ja_5', \
                  # 'EOM_7G_1' : 'ja_1', \
                  # 'EOM_7G_2'  : 'ja_0', \
                  # 'EOM_2G': 'ja_6', \
                  # 'AOM' : 'ja_7'}

import math
from scipy.optimize import curve_fit
import sys
sys.setrecursionlimit(1500)

# experiment type (User setting)
ex_resonance = 0   #0 / 1-
ex_rabi = 1         #1 / 0-

# experiment variables (User setting)
res_freq = int(12.642812118E9)# + int(4e3)  # for - 3A

center_frequency = res_freq + detun_freq

half_width = 0#e3#e2#e3#e3#e3#e2#e2#1e3#int(5e3)
# half_width = int(5e3)
sweep_step = int(4E2)

# thres = 0.5 / detection time 150us

T_cool= 4 # denotes how many 'T_0p5ms' steps we take  
T_0p5ms = int(500e2) # 500 us
T_init=int(150e2) 
T_mw_step=int(10e2) # 10 us
T_det=int(150e2) # 150 us
N_average = 2000

T_control = T_mw_step # 10 us
X_control = T_control/100
N_qubit_control = 30    # Until 50*10=500 us / total time = X_control * N_qubit_control (us)

N_threshold = 0.5

# calculated parameters (used in the experiment)
N_qubit_control += 1
N_detuning = math.floor(2*half_width/sweep_step) + 1
max_data_count = N_detuning*N_qubit_control*N_average

#%% 
# Sequencer
'''
Control parameter name
            'Microwave_12_6GHz' : 'C2_AOM_200MHz', ja_3
            'EOM_14_7GHz' : 'C1_AOM_200MHz', jb_1
            'EOM_2_1GHz' : 'C1_AOM_210MHz', jb_3
            'AOM_200_205MHz' : 'C1_Microwave_SW', jb_5
            'AOM_on_off' : 'single_shot', jb_7

Time for each stage: 1ms 100us 1us~10ms 2ms
1~10us interval
'''
s=SequencerProgram()

#Reset run_number
s.load_immediate(reg[6], 0, 'qubit control time')
s.load_immediate(reg[12], 0, 'reg[12] is the number of runs done')

# Start of the repeating part
s.repeat_run = \
\
s.load_immediate(reg[7], 0, 'not in usage')
s.load_immediate(reg[8], 0, 'reg[8] will be used to count the measured result of PMT')
s.load_immediate(reg[9], 0, 'reg[9] will be used to count the loop of cooling timer')
s.load_immediate(reg[11], 0, 'reg[11] will be used to count the loop of detection timer')
s.load_immediate(reg[5], 0, 'reg[5] will be used to count the loop of microwave timer')

#Cooling stage (1ms)
#14.7GHz : EOM_14_7GHz on
#200MHz :  AOM_on_off on
#          AOM_200_205MHz on
s.set_output_port(hd.external_control_port, [(hd.EOM_7G_1_out, 1), (hd.EOM_7G_2_out, 1), (hd.AOM_out, 1)], 'Start Cooling')
s.repeat_cooling = \
\
s.wait_n_clocks(T_0p5ms, 'Cooling for 50000 * 10 ns = 0.5 ms')
s.add(reg[9], reg[9], 1, 'reg[9]++')
s.branch_if_less_than('repeat_cooling', reg[9], T_cool, 'Wait for 2ms')

#Initialization stage (100us)
#EOM 2.1GHz : EOM_2_1GHz on
#200MHz : AOM_on_off on
#         AOM_200_205MHz on
s.set_output_port(hd.external_control_port, [(hd.EOM_7G_1_out, 0), (hd.EOM_7G_2_out, 0), (hd.EOM_2G_out, 1)], 'Start Initialization')
s.wait_n_clocks(T_init, 'Initialization for 50000 * 10 ns = 500 us')
s.set_output_port(hd.external_control_port, [(hd.AOM_out, 0),(hd.EOM_2G_out, 0)], 'End Initialization')
s.wait_n_clocks(270, 'Wait for the AOM completely off')

#Microwave horn (1us~10ms)
#Microwave : Microwave_12_6GHz on
s.repeat_microwave = \
\
s.branch_if_equal('no_microwave_time', reg[6], 0, 'Microwave is off when reg[6] is 0')
s.set_output_port(hd.external_control_port, [(hd.MW_out, 1)], 'Start Qubit control')
s.wait_n_clocks(T_control-7, 'Interval for 1000 * 10 ns = 10 us')
s.add(reg[5], reg[5], 1, 'reg[5]++')
s.branch_if_less_than('repeat_microwave', reg[5], reg[6], 'Repeat until microwave is on for wanted time')
s.wait_n_clocks(3)
s.set_output_port(hd.external_control_port, [(hd.MW_out, 0)], 'End Qubit control')
s.wait_n_clocks(10, 'Interval for 10 * 10 ns = 0.1 us')
#Detection
#205MHz : AOM_on_off on
#         AOM_200_205 off
s.no_microwave_time = \
\
s.set_output_port(hd.external_control_port, [(hd.AOM_out, 1)], 'Start Detection')
s.wait_n_clocks(270, 'Wait for AOM ON')
s.trigger_out([hd.PMT_counter_reset], 'Reset single counter')
s.nop()
s.set_output_port(hd.counter_control_port, [(hd.PMT_counter_enable, 1)], 'Start counter')
s.wait_n_clocks(T_det, 'Detection for 15000 * 10 ns 150 us')
s.set_output_port(hd.counter_control_port, [(hd.PMT_counter_enable, 0)], 'Stop counter')
s.read_counter(reg[8], hd.PMT_counter_result)
s.write_to_fifo(reg[12], reg[6], reg[8], 5, 'Show data')


s.set_output_port(hd.external_control_port, [(hd.EOM_7G_1_out, 1), (hd.EOM_7G_2_out, 1), (hd.AOM_out, 1)], 'Resume Cooling')

s.add(reg[12], reg[12], 1)
s.branch_if_less_than('repeat_run', reg[12], N_average,'Repeat')
s.load_immediate(reg[12], 0, 'l')

# Decide whether we will repeat running
s.add(reg[6], reg[6], 1, 'reg[6]++')
s.branch_if_less_than('repeat_run', reg[6], N_qubit_control,'Repeat, increasing microwave time')

s.stop()
#%%

if __name__ == '__main__':
    if 'sequencer' in vars(): # To close the previously opened device when re-running the script with "F5"
        sequencer.close()
    sequencer = ArtyS7('COM4')
    sequencer.check_version(hd.HW_VERSION)
    s.program(show=False, target=sequencer)
    sequencer.auto_mode()
    
    from tqdm import tqdm
    import socket
    
    ip = '172.22.22.206'
    port = 18    
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((ip, port))
    sock.send(('FREQ '+ str(center_frequency) +'\n').encode())

# definition of the class for data acquisition 
    class Data_acquisition(object):
     
        def __init__(self, flag, fig, axes):       
            self.flag = flag
            self.fig = fig
            self.axes = axes
            self.X_data = []
            self.Y_data = []
            self.X_histogram = []
            self.Y_histogram = []
            self.data_buffer = []           
            self.population_data = [[] for i in range(N_detuning)]
            self.x_track = []
            self.frequency_count = 0
            self.data_count = 0
            self.sync_count = 0
            self.histogram_max = 40
            
            for i in range(self.histogram_max + 1):
                self.X_histogram.append(i)
            self.Y_histogram = [0 for j in range(self.histogram_max + 1)]
            
            for i in range(N_qubit_control):
                self.x_track.append(i*X_control)  
            for i in range(N_detuning):
                self.x_track += self.x_track
            
            self.line_1 = self.axes[0].bar(self.X_histogram, self.Y_histogram, width=0.5, color='b')             
            self.line_2, = self.axes[1].plot([],[],'ro', linewidth = 0, markersize = 3)  

            self.t1 = threading.Thread(target=self.execute_experiment)
            self.t1.daemon = True     
            self.t1.start()  
               
        def execute_experiment(self):
            start_time = time.time()
            time.sleep(2)
            for i in range(N_detuning):
                sequencer.flush_Output_FIFO()
                sequencer.start_sequencer()
            
                while(sequencer.sequencer_running_status() == 'running' or 
                      (sequencer.sequencer_running_status() == 'stopped' and sequencer.fifo_data_length() > 0)):
                    fifo_data_count = sequencer.fifo_data_length()
#                    print(fifo_data_count)
                    fifo_data_temp = sequencer.read_fifo_data(fifo_data_count)
                    
                    self.data_count += fifo_data_count
                    self.analog_to_digital(fifo_data_temp, fifo_data_count)
                    self.process_data()                 
                    
                print("%0.2f percent complete" % (100*self.data_count/max_data_count))
                    
                self.frequency_count += 1
            
            elapsed_time = time.time() - start_time
            print("Data acquisition time is %f seconds" %(elapsed_time))
            self.save_data()
            
            sequencer.close()
        
            return 'Done measuring...'

        def analog_to_digital(self, fifo_data_temp, fifo_data_count):
            for i in range(fifo_data_count):
                if fifo_data_temp[i][2] > self.histogram_max:
                    for j in range(self.histogram_max, fifo_data_temp[i][2]):
                        self.X_histogram.append(j+1)
                    Y_histogram_extend = []
                    for j in range(self.histogram_max, fifo_data_temp[i][2]):
                        Y_histogram_extend.append(0)
                    Y_histogram_extend[-1] = 1
                    self.Y_histogram += Y_histogram_extend
                    
                    self.histogram_max = fifo_data_temp[i][2]
                    
                else:
                    self.Y_histogram[fifo_data_temp[i][2]] += 1
                    
                self.data_buffer.append(fifo_data_temp[i][2])
                
            if len(self.data_buffer) >= N_average:
                sum_1 = 0
                for i in range(N_average):
                    if self.data_buffer[i] > N_threshold:
                        sum_1 += 1
                    else:
                        sum_1 = sum_1
                population = sum_1/N_average
                self.population_data[self.frequency_count].append(population)

                for i in range(N_average):
                    self.data_buffer.remove(self.data_buffer[0])
            
#                print(len(self.data_buffer))
            
            else:
                return 'next round'

        def sort_max(self, real_time_data):
            for i in range(len(real_time_data)):
                for j in range(len(real_time_data[i])-1):
                    if real_time_data[i][j] < real_time_data[i][j+1]:
                        p = real_time_data[i][j]
                        n = real_time_data[i][j+1]
                        real_time_data[i][j+1] = p
                        real_time_data[i][j] = n
                    else:
                        p = real_time_data[i][j]
                        n = real_time_data[i][j+1]
                        real_time_data[i][j] = p
                        real_time_data[i][j+1] = n
       
                for j in range(len(real_time_data[i])-1):
                    while real_time_data[i][j] < real_time_data[i][j+1]:
                        self.sort_max(real_time_data)
            
            return real_time_data

        def save_data(self):
            all_data = {'x_hist': self.X_histogram, 'y_hist': self.Y_histogram, 'x_data': self.X_data, 'y_data': self.Y_data, 'MW_freq': center_frequency, 'detun_freq': detun_freq, 'N_average': N_average, 'sweep_step': sweep_step}
            
            
            pkl_name = my_dir + file_name + custom_stirng
            
#            with open (pkl_name + '_detun_' + str(detun_freq) + '.pkl', 'wb') as fw:
            with open (pkl_name + '.pkl', 'wb') as fw:
                pickle.dump(all_data, fw)
                
            #self.ani.save(pkl_name + '_' + str(center_frequency) + '.gif', writer='imagemagick', fps=60)
            print('saved data')
            sock.close()

        def mean_max(self, sorted_data, empty):           
            scan = 3
            for i in range(len(sorted_data)):
                sum_max = 0
                for j in range(scan):
                    if scan < len(sorted_data[i]):                        
                        sum_max += sorted_data[i][j]
                    else:
                        sum_max = sum_max
            
                mean = sum_max/scan
                empty.append(mean)
            
            return empty
        
        def process_data(self):  
            if self.sync_count < self.data_count and self.sync_count < max_data_count:
                start_time = time.time()
                real_time_data = self.population_data
                empty = []
            
                if self.flag == 0: # Set to the resonance scanning experiment  
                    sorted_data = self.sort_max(real_time_data)
                    inter_Y_data = self.mean_max(sorted_data, empty)
                    inter_X_data = []
                    if 0 < sweep_step <= 1e2:
                        self.divider = 1
                        self.dimension = 'Hz'
                    elif 1e2 < sweep_step <= 1e5:
                        self.divider = 1e3
                        self.dimension = 'kHz'
                    elif 1e5 < sweep_step <= 1e8:
                        self.divider = 1e6
                        self.dimension = 'MHz'
                    for i in range(len(inter_Y_data)):
                        inter_X_data.append((-half_width + sweep_step*i)/self.divider)
                    
                    self.X_data = inter_X_data
                    self.Y_data = inter_Y_data  
                    
                    #self.process_data()                            
                
                elif self.flag == 1: # Set to the rabi oscillation experiment
                    inter_Y_data = []
                    inter_X_data = []
                    for i in range(len(real_time_data)):
                        inter_Y_data += real_time_data[i]
                    for i in range(len(inter_Y_data)):
                        inter_X_data.append(self.x_track[i])
                        
                    #self.process_data()
                    self.X_data = inter_X_data
                    self.Y_data = inter_Y_data  
                self.sync_count = self.data_count

            elif self.sync_count == max_data_count:
                elapsed_time = time.time() - start_time
                
                print("Data process time is %f seconds" %(elapsed_time))
                
                return 'done processing'
                

  
        def update_plot(self,i):
            for i, h in enumerate(self.line_1):
                #if i == 0:
                    
                self.line_1[i].set_height(self.Y_histogram[i])
            
            self.line_2.set_data(self.X_data, self.Y_data)
        
            self.axes[0].set_ylim(0, max(self.Y_histogram)+50)
            
            if self.flag == 0:
                try:
                    self.axes[1].set_xlim(min(self.X_data)*1.05, max(self.X_data)*1.05)        
                    self.axes[1].set_ylim(0, 1)
                except:
                    pass
            
            if self.flag == 1:
                self.axes[1].set_xlim(-0.05, X_control * N_qubit_control)        #X_control
                self.axes[1].set_ylim(0, 1)

            self.axes[0].figure.canvas.draw()

            return (self.line_2, )
                
        def real_time_plot(self):
            self.ani = animation.FuncAnimation(self.fig, self.update_plot, interval=10, blit=True)
            self.fig.show() 
                       
            
            
           
# Authentication of the experiment            
    if ex_resonance == 1 and ex_rabi == 0:
        flag = 0
    elif ex_resonance == 0 and ex_rabi == 1:
        flag = 1
    else:
        print("Please specify the experiment type")
        sys.exit()
     
# Execution of the experiment               
    fig, axes = plt.subplots(nrows = 2, ncols = 1, figsize=(6,6), gridspec_kw={'height_ratios' : [1,3]})
    data_acquire = Data_acquisition(flag, fig, axes)

    data_acquire.real_time_plot()
    #data_acquire.save_data()
   
   
            
    
def rabi_fit(t, A, B):
	return A*np.sin(B*t)**2
	
# file_save(Data_acquisition.population_data, Data_acquisition.)
def save_plot():
    fig2, axes2 = plt.subplots(nrows = 2, ncols = 1, figsize=(8,8), gridspec_kw={'height_ratios' : [1,3]})
    
    Y_to_save = np.array(data_acquire.Y_histogram)*1
    for ii in range(int(N_threshold)+1):
        Y_to_save[ii] = (data_acquire.Y_histogram[ii]/data_acquire.Y_histogram[0]) * max(Y_to_save[int(N_threshold)+1:])
    line_21 = axes2[0].bar(data_acquire.X_histogram, Y_to_save, width=0.5, color='b')             
    line_22, = axes2[1].plot(data_acquire.X_data, data_acquire.Y_data,'ro', linewidth = 0, markersize = 3)  
    
    axes2[0].set_ylim(0, Y_to_save[0]*1.02)
    
    for ii in range(int(N_threshold)+1):
        line_21[ii].set_color('g')
    
    if data_acquire.flag == 0:
        fig2.suptitle('Resonance scanning')
        axes2[1].set_xlim(min(data_acquire.X_data)*1.05, max(data_acquire.X_data)*1.05)        
        axes2[1].set_ylim(0, 1)
    
    if data_acquire.flag == 1:
        fig2.suptitle('Rabi Oscillation')
        axes2[1].set_xlim(-0.05, X_control * N_qubit_control)        #X_control
        axes2[1].set_ylim(0, 1)
        
    popt, pcov = curve_fit(rabi_fit, np.array(data_acquire.X_data)*1e-6, data_acquire.Y_data, p0=[0.5, 15000])
    t_line = np.linspace(-0.05*1e-6, X_control * N_qubit_control*1e-6, 2000)
    axes2[1].plot(t_line*1e6, rabi_fit(t_line, *popt), color="C1")
    axes2[1].text(10, 0.9, r"$\tau_{Rabi}$ = %.2f $\mathrm{\mu s}$" % (np.pi/popt[1]*1e6))
	
    axes2[0].set_xlabel('PMT count')
    axes2[0].set_ylabel('Num of events')            
    axes2[0].axvline(x=N_threshold, color='k')
    if data_acquire.flag == 1:
        axes2[1].set_xlabel('Time [us]')
    else:
        axes2[1].set_xlabel('Detuing [%s]' % data_acquire.dimension)
    axes2[1].set_ylabel(r'Probability of $\left| 1 \right>$')
    
    png_name = my_dir + file_name + custom_stirng
#    fig2.savefig(png_name + '_detun_' + str(detun_freq) + '.png', dpi=300)
    fig2.savefig(png_name + '.png', dpi=300)	
    return (popt, pcov)
