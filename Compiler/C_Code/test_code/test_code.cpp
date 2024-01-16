#include "RFSoC_Driver.h"

int main(){
    DAC dac_0;
    dac_0.set_addr(XPAR_DAC_CONTROLLER_0_BASEADDR);
    dac_0.flush_fifo();

    DAC dac_1;
    dac_1.set_addr(XPAR_DAC_CONTROLLER_1_BASEADDR);
    dac_1.flush_fifo();

    DAC dac_2;
    dac_2.set_addr(XPAR_DAC_CONTROLLER_2_BASEADDR);
    dac_2.flush_fifo();

    DAC dac_3;
    dac_3.set_addr(XPAR_DAC_CONTROLLER_3_BASEADDR);
    dac_3.flush_fifo();

    DAC dac_4;
    dac_4.set_addr(XPAR_DAC_CONTROLLER_4_BASEADDR);
    dac_4.flush_fifo();

    DAC dac_5;
    dac_5.set_addr(XPAR_DAC_CONTROLLER_5_BASEADDR);
    dac_5.flush_fifo();

    DAC dac_6;
    dac_6.set_addr(XPAR_DAC_CONTROLLER_6_BASEADDR);
    dac_6.flush_fifo();

    DAC dac_7;
    dac_7.set_addr(XPAR_DAC_CONTROLLER_7_BASEADDR);
    dac_7.flush_fifo();

    TTL_out ttl_out_0(XPAR_TTL_OUT_0_BASEADDR);
    ttl_out_0.flush_fifo();

    TTL_out ttl_out_1(XPAR_TTL_OUT_1_BASEADDR);
    ttl_out_1.flush_fifo();

    TTL_out ttl_out_2(XPAR_TTL_OUT_2_BASEADDR);
    ttl_out_2.flush_fifo();

    TTL_out ttl_out_3(XPAR_TTL_OUT_3_BASEADDR);
    ttl_out_3.flush_fifo();

    TTL_out ttl_out_4(XPAR_TTL_OUT_4_BASEADDR);
    ttl_out_4.flush_fifo();

    TTLx8_out ttlx8_out_0(XPAR_TTLX8_OUT_0_BASEADDR);
    ttlx8_out_0.flush_fifo();

    TTLx8_out ttlx8_out_1(XPAR_TTLX8_OUT_1_BASEADDR);
    ttlx8_out_1.flush_fifo();

    TTLx8_out ttlx8_out_2(XPAR_TTLX8_OUT_2_BASEADDR);
    ttlx8_out_2.flush_fifo();

    TTLx8_out ttlx8_out_3(XPAR_TTLX8_OUT_3_BASEADDR);
    ttlx8_out_3.flush_fifo();

    TTLx8_out ttlx8_out_4(XPAR_TTLX8_OUT_4_BASEADDR);
    ttlx8_out_4.flush_fifo();

    TimeController tc_0(XPAR_TIMECONTROLLER_0_BASEADDR);
    tc_0.auto_stop();
    tc_0.reset();

    dac_0.set_freq(0);
    delay(8);
    dac_0.set_amp(1.0);
    delay(800000);
    dac_0.set_amp(0.0);
    delay(8);
    dac_0.set_freq(1000000);
    delay(8);
    for(int i= 0 ; i < 1000; i++){
        dac_0.set_amp(i/1000.0);
        delay(8);
    }
    dac_0.set_amp(1.0);
    delay(32);
    dac_0.set_freq(1234000);
    delay(8);
    dac_0.set_freq(432189);
    delay(1000);
    dac_0.set_freq(123456);
    delay(1000);
    dac_0.set_freq(1000000);
    delay(1000);
    for(int i =0; i < 1000; i++){
        dac_0.set_amp((999-i)/1000.0);
        delay(8);
    }

    dac_0.set_freq(0);
    int64_t length = 832;
    double amp_list[length] = {0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7,
        0.8, 0.9, 1.0, 0.8, 0.6, 0.5, 0.4, 0.3, 0.2,
        0.0, 1.5625e-06, 6.25e-06, 1.40625e-05, 2.5e-05, 3.90625e-05, 5.625e-05, 7.65625e-05,
0.0001, 0.0001265625, 0.00015625, 0.0001890625, 0.000225, 0.0002640625, 0.00030625, 0.0003515625,
0.0004, 0.0004515625, 0.00050625, 0.0005640625, 0.000625, 0.0006890625, 0.00075625, 0.0008265625,
0.0009, 0.0009765625, 0.00105625, 0.0011390625, 0.001225, 0.0013140625, 0.00140625, 0.0015015625,
0.0016, 0.0017015625, 0.00180625, 0.0019140625, 0.002025, 0.0021390625, 0.00225625, 0.0023765625,
0.0025, 0.0026265625, 0.00275625, 0.0028890625, 0.003025, 0.0031640625, 0.00330625, 0.0034515625,
0.0036, 0.0037515625, 0.00390625, 0.0040640625, 0.004225, 0.0043890625, 0.00455625, 0.0047265625,
0.0049, 0.0050765625, 0.00525625, 0.0054390625, 0.005625, 0.0058140625, 0.00600625, 0.0062015625,
0.0064, 0.0066015625, 0.00680625, 0.0070140625, 0.007225, 0.0074390625, 0.00765625, 0.0078765625,
0.0081, 0.0083265625, 0.00855625, 0.0087890625, 0.009025, 0.0092640625, 0.00950625, 0.0097515625,
0.01, 0.0102515625, 0.01050625, 0.0107640625, 0.011025, 0.0112890625, 0.01155625, 0.0118265625,
0.0121, 0.0123765625, 0.01265625, 0.0129390625, 0.013225, 0.0135140625, 0.01380625, 0.0141015625,
0.0144, 0.0147015625, 0.01500625, 0.0153140625, 0.015625, 0.0159390625, 0.01625625, 0.0165765625,
0.0169, 0.0172265625, 0.01755625, 0.0178890625, 0.018225, 0.0185640625, 0.01890625, 0.0192515625,
0.0196, 0.0199515625, 0.02030625, 0.0206640625, 0.021025, 0.0213890625, 0.02175625, 0.0221265625,
0.0225, 0.0228765625, 0.02325625, 0.0236390625, 0.024025, 0.0244140625, 0.02480625, 0.0252015625,
0.0256, 0.0260015625, 0.02640625, 0.0268140625, 0.027225, 0.0276390625, 0.02805625, 0.0284765625,
0.0289, 0.0293265625, 0.02975625, 0.0301890625, 0.030625, 0.0310640625, 0.03150625, 0.0319515625,
0.0324, 0.0328515625, 0.03330625, 0.0337640625, 0.034225, 0.0346890625, 0.03515625, 0.0356265625,
0.0361, 0.0365765625, 0.03705625, 0.0375390625, 0.038025, 0.0385140625, 0.03900625, 0.0395015625,
0.04, 0.0405015625, 0.04100625, 0.0415140625, 0.042025, 0.0425390625, 0.04305625, 0.0435765625,
0.0441, 0.0446265625, 0.04515625, 0.0456890625, 0.046225, 0.0467640625, 0.04730625, 0.0478515625,
0.0484, 0.0489515625, 0.04950625, 0.0500640625, 0.050625, 0.0511890625, 0.05175625, 0.0523265625,
0.0529, 0.0534765625, 0.05405625, 0.0546390625, 0.055225, 0.0558140625, 0.05640625, 0.0570015625,
0.0576, 0.0582015625, 0.05880625, 0.0594140625, 0.060025, 0.0606390625, 0.06125625, 0.0618765625,
0.0625, 0.0631265625, 0.06375625, 0.0643890625, 0.065025, 0.0656640625, 0.06630625, 0.0669515625,
0.0676, 0.0682515625, 0.06890625, 0.0695640625, 0.070225, 0.0708890625, 0.07155625, 0.0722265625,
0.0729, 0.0735765625, 0.07425625, 0.0749390625, 0.075625, 0.0763140625, 0.07700625, 0.0777015625,
0.0784, 0.0791015625, 0.07980625, 0.0805140625, 0.081225, 0.0819390625, 0.08265625, 0.0833765625,
0.0841, 0.0848265625, 0.08555625, 0.0862890625, 0.087025, 0.0877640625, 0.08850625, 0.0892515625,
0.09, 0.0907515625, 0.09150625, 0.0922640625, 0.093025, 0.0937890625, 0.09455625, 0.0953265625,
0.0961, 0.0968765625, 0.09765625, 0.0984390625, 0.099225, 0.1000140625, 0.10080625, 0.1016015625,
0.1024, 0.1032015625, 0.10400625, 0.1048140625, 0.105625, 0.1064390625, 0.10725625, 0.1080765625,
0.1089, 0.1097265625, 0.11055625, 0.1113890625, 0.112225, 0.1130640625, 0.11390625, 0.1147515625,
0.1156, 0.1164515625, 0.11730625, 0.1181640625, 0.119025, 0.1198890625, 0.12075625, 0.1216265625,
0.1225, 0.1233765625, 0.12425625, 0.1251390625, 0.126025, 0.1269140625, 0.12780625, 0.1287015625,
0.1296, 0.1305015625, 0.13140625, 0.1323140625, 0.133225, 0.1341390625, 0.13505625, 0.1359765625,
0.1369, 0.1378265625, 0.13875625, 0.1396890625, 0.140625, 0.1415640625, 0.14250625, 0.1434515625,
0.1444, 0.1453515625, 0.14630625, 0.1472640625, 0.148225, 0.1491890625, 0.15015625, 0.1511265625,
0.1521, 0.1530765625, 0.15405625, 0.1550390625, 0.156025, 0.1570140625, 0.15800625, 0.1590015625,
0.16, 0.1610015625, 0.16200625, 0.1630140625, 0.164025, 0.1650390625, 0.16605625, 0.1670765625,
0.1681, 0.1691265625, 0.17015625, 0.1711890625, 0.172225, 0.1732640625, 0.17430625, 0.1753515625,
0.1764, 0.1774515625, 0.17850625, 0.1795640625, 0.180625, 0.1816890625, 0.18275625, 0.1838265625,
0.1849, 0.1859765625, 0.18705625, 0.1881390625, 0.189225, 0.1903140625, 0.19140625, 0.1925015625,
0.1936, 0.1947015625, 0.19580625, 0.1969140625, 0.198025, 0.1991390625, 0.20025625, 0.2013765625,
0.2025, 0.2036265625, 0.20475625, 0.2058890625, 0.207025, 0.2081640625, 0.20930625, 0.2104515625,
0.2116, 0.2127515625, 0.21390625, 0.2150640625, 0.216225, 0.2173890625, 0.21855625, 0.2197265625,
0.2209, 0.2220765625, 0.22325625, 0.2244390625, 0.225625, 0.2268140625, 0.22800625, 0.2292015625,
0.2304, 0.2316015625, 0.23280625, 0.2340140625, 0.235225, 0.2364390625, 0.23765625, 0.2388765625,
0.2401, 0.2413265625, 0.24255625, 0.2437890625, 0.245025, 0.2462640625, 0.24750625, 0.2487515625,
0.25, 0.2512515625, 0.25250625, 0.2537640625, 0.255025, 0.2562890625, 0.25755625, 0.2588265625,
0.2601, 0.2613765625, 0.26265625, 0.2639390625, 0.265225, 0.2665140625, 0.26780625, 0.2691015625,
0.2704, 0.2717015625, 0.27300625, 0.2743140625, 0.275625, 0.2769390625, 0.27825625, 0.2795765625,
0.2809, 0.2822265625, 0.28355625, 0.2848890625, 0.286225, 0.2875640625, 0.28890625, 0.2902515625,
0.2916, 0.2929515625, 0.29430625, 0.2956640625, 0.297025, 0.2983890625, 0.29975625, 0.3011265625,
0.3025, 0.3038765625, 0.30525625, 0.3066390625, 0.308025, 0.3094140625, 0.31080625, 0.3122015625,
0.3136, 0.3150015625, 0.31640625, 0.3178140625, 0.319225, 0.3206390625, 0.32205625, 0.3234765625,
0.3249, 0.3263265625, 0.32775625, 0.3291890625, 0.330625, 0.3320640625, 0.33350625, 0.3349515625,
0.3364, 0.3378515625, 0.33930625, 0.3407640625, 0.342225, 0.3436890625, 0.34515625, 0.3466265625,
0.3481, 0.3495765625, 0.35105625, 0.3525390625, 0.354025, 0.3555140625, 0.35700625, 0.3585015625,
0.36, 0.3615015625, 0.36300625, 0.3645140625, 0.366025, 0.3675390625, 0.36905625, 0.3705765625,
0.3721, 0.3736265625, 0.37515625, 0.3766890625, 0.378225, 0.3797640625, 0.38130625, 0.3828515625,
0.3844, 0.3859515625, 0.38750625, 0.3890640625, 0.390625, 0.3921890625, 0.39375625, 0.3953265625,
0.3969, 0.3984765625, 0.40005625, 0.4016390625, 0.403225, 0.4048140625, 0.40640625, 0.4080015625,
0.4096, 0.4112015625, 0.41280625, 0.4144140625, 0.416025, 0.4176390625, 0.41925625, 0.4208765625,
0.4225, 0.4241265625, 0.42575625, 0.4273890625, 0.429025, 0.4306640625, 0.43230625, 0.4339515625,
0.4356, 0.4372515625, 0.43890625, 0.4405640625, 0.442225, 0.4438890625, 0.44555625, 0.4472265625,
0.4489, 0.4505765625, 0.45225625, 0.4539390625, 0.455625, 0.4573140625, 0.45900625, 0.4607015625,
0.4624, 0.4641015625, 0.46580625, 0.4675140625, 0.469225, 0.4709390625, 0.47265625, 0.4743765625,
0.4761, 0.4778265625, 0.47955625, 0.4812890625, 0.483025, 0.4847640625, 0.48650625, 0.4882515625,
0.49, 0.4917515625, 0.49350625, 0.4952640625, 0.497025, 0.4987890625, 0.50055625, 0.5023265625,
0.5041, 0.5058765625, 0.50765625, 0.5094390625, 0.511225, 0.5130140625, 0.51480625, 0.5166015625,
0.5184, 0.5202015625, 0.52200625, 0.5238140625, 0.525625, 0.5274390625, 0.52925625, 0.5310765625,
0.5329, 0.5347265625, 0.53655625, 0.5383890625, 0.540225, 0.5420640625, 0.54390625, 0.5457515625,
0.5476, 0.5494515625, 0.55130625, 0.5531640625, 0.555025, 0.5568890625, 0.55875625, 0.5606265625,
0.5625, 0.5643765625, 0.56625625, 0.5681390625, 0.570025, 0.5719140625, 0.57380625, 0.5757015625,
0.5776, 0.5795015625, 0.58140625, 0.5833140625, 0.585225, 0.5871390625, 0.58905625, 0.5909765625,
0.5929, 0.5948265625, 0.59675625, 0.5986890625, 0.600625, 0.6025640625, 0.60450625, 0.6064515625,
0.6084, 0.6103515625, 0.61230625, 0.6142640625, 0.616225, 0.6181890625, 0.62015625, 0.6221265625,
0.6241, 0.6260765625, 0.62805625, 0.6300390625, 0.632025, 0.6340140625, 0.63600625, 0.6380015625,
0.64, 0.6420015625, 0.64400625, 0.6460140625, 0.648025, 0.6500390625, 0.65205625, 0.6540765625,
0.6561, 0.6581265625, 0.66015625, 0.6621890625, 0.664225, 0.6662640625, 0.66830625, 0.6703515625,
0.6724, 0.6744515625, 0.67650625, 0.6785640625, 0.680625, 0.6826890625, 0.68475625, 0.6868265625,
0.6889, 0.6909765625, 0.69305625, 0.6951390625, 0.697225, 0.6993140625, 0.70140625, 0.7035015625,
0.7056, 0.7077015625, 0.70980625, 0.7119140625, 0.714025, 0.7161390625, 0.71825625, 0.7203765625,
0.7225, 0.7246265625, 0.72675625, 0.7288890625, 0.731025, 0.7331640625, 0.73530625, 0.7374515625,
0.7396, 0.7417515625, 0.74390625, 0.7460640625, 0.748225, 0.7503890625, 0.75255625, 0.7547265625,
0.7569, 0.7590765625, 0.76125625, 0.7634390625, 0.765625, 0.7678140625, 0.77000625, 0.7722015625,
0.7744, 0.7766015625, 0.77880625, 0.7810140625, 0.783225, 0.7854390625, 0.78765625, 0.7898765625,
0.7921, 0.7943265625, 0.79655625, 0.7987890625, 0.801025, 0.8032640625, 0.80550625, 0.8077515625,
0.81, 0.8122515625, 0.81450625, 0.8167640625, 0.819025, 0.8212890625, 0.82355625, 0.8258265625,
0.8281, 0.8303765625, 0.83265625, 0.8349390625, 0.837225, 0.8395140625, 0.84180625, 0.8441015625,
0.8464, 0.8487015625, 0.85100625, 0.8533140625, 0.855625, 0.8579390625, 0.86025625, 0.8625765625,
0.8649, 0.8672265625, 0.86955625, 0.8718890625, 0.874225, 0.8765640625, 0.87890625, 0.8812515625,
0.8836, 0.8859515625, 0.88830625, 0.8906640625, 0.893025, 0.8953890625, 0.89775625, 0.9001265625,
0.9025, 0.9048765625, 0.90725625, 0.9096390625, 0.912025, 0.9144140625, 0.91680625, 0.9192015625,
0.9216, 0.9240015625, 0.92640625, 0.9288140625, 0.931225, 0.9336390625, 0.93605625, 0.9384765625,
0.9409, 0.9433265625, 0.94575625, 0.9481890625, 0.950625, 0.9530640625, 0.95550625, 0.9579515625,
0.9604, 0.9628515625, 0.96530625, 0.9677640625, 0.970225, 0.9726890625, 0.97515625, 0.9776265625,
0.9801, 0.9825765625, 0.98505625, 0.9875390625, 0.990025, 0.9925140625, 0.99500625, 0.9975015625
    };

    delay(8);
    dac_0.set_config(0.0,0,0.25,0);
    delay(8);
    for(int i = 0; i < length; i++){
        dac_0.set_amp(amp_list[i]);
        delay(80);
    }

    dac_0.set_config(0.0,0,0.0,0);

    tc_0.auto_start();

}