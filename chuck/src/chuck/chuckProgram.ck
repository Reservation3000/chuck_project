
global float gainControl_Melody;
global float gainControl_Beat;
global float valueToTranslateSpeed;
global int freqControl;

1.0 => valueToTranslateSpeed;            //改變整體速度的參數

0   => freqControl;                     //改變整體音高的參數
1.0 => gainControl_Melody;              //改變旋律音量的參數
1.0 => gainControl_Beat;                //改變節奏音量的參數

fun dur currentBeat()
{
    0.25 * valueToTranslateSpeed::second => dur result;
    return result;
}




// =========================================================================================================================
// finction=================================================================================================================
// =========================================================================================================================


// 爬音 =====================================================================================================================
SinOsc osc => ADSR envelop => dac; 
0.2 => osc.gain;

[0,4,7,12] @=> int major[];
[0,3,7,12] @=> int minor[];
[0,3,6,15] @=> int dim[];

65 => int offest;
(currentBeat()/2, currentBeat()/4, 0.0, 1::ms) => envelop.set;

fun void playChords(){
   while(true)
   {
       playTwoBeat(-7, major);
       playTwoBeat(-2, major);
       playOneBeat(-7, major);
       playOneBeat(-5, minor);
       playOneBeat(0, major);
       playOneBeat(-7, major);
       playHalfBeat(0, major);
       playHalfBeat(-7, major);
       playOneBeat(-7, major);
       playHalfBeat(-2, major);
       playHalfBeat(0, major);
       playOneBeat(-7, major);
       playHalfBeat(-7, major);
       playHalfBeat(-2, major);        
       playOneBeat(-7, major);
       playHalfBeat(-2, major);
       playHalfBeat(0, major);
       playOneBeat(2, minor);
       playOneBeat(0, major);
       playOneBeat(-7, major);
       4 * currentBeat() => now;
       playOneBeat(-2, major);
       playOneBeat(-7, major);
       4 * currentBeat() => now;
       playOneBeat(-5, minor);
       playOneBeat(-7, major);
       playHalfBeat(-7, major);
       4 * currentBeat() => now;
       playHalfBeat(-2, major);
       playHalfBeat(0, major);
       playOneBeat(-7, major);
       playHalfBeat(-7, major);
       playTwoBeat(-7, major);
       playHalfBeat(-7, major);
    }
}

fun void playHalfBeat(int pos , int chord[]){
    for(0 => int j; j < 4; j++)
    {
        Std.mtof(chord[j] + offest + pos) => osc.freq;
        1 => envelop.keyOn;
        currentBeat() => now;
    }
}

fun void playOneBeat(int pos , int chord[]){
    for(0 =>  int i; i < 2; i++)
    {
        for(0 => int j; j < 4; j++)
        {
            Std.mtof(chord[j] + offest + pos + freqControl ) => osc.freq;
            1 => envelop.keyOn;
            currentBeat() => now;
        }
    }
}

fun void playTwoBeat(int pos , int chord[]){
    for(0 =>  int i; i < 4; i++)
    {
        for(0 => int j; j < 4; j++)
        {
            Std.mtof(chord[j] + offest + pos + freqControl ) => osc.freq;
            1 => envelop.keyOn;
            currentBeat() => now;
        }
    }
}

// 旋律 =====================================================================================================================
fun void melod(){
    // 旋律1
    [   77, 77, 77, 77, 79, 77, 74, 77, 79, 77, 77, 0,    65, 65, 65, 65, 67, 65, 62, 65, 67, 65, 65, 0,
        77, 77, 74, 77, 79, 77, 74, 74, 77,               60, 67, 67, 69, 60, 65, 65, 62, 65, 0,
        81, 79, 77, 79, 77, 74, 72, 77, 77, 0,            84, 81, 79, 81, 79, 77, 79, 81, 72, 0,
        72, 79, 79, 81, 0, 72, 77, 77, 74, 77, 0,         81, 79, 77, 79, 76, 74, 71, 74, 74,
        74, 77, 79, 81, 79, 77, 74, 72, 74, 74, 77, 0,    62, 65, 67, 72, 67, 65, 62, 60, 62, 62, 65, 0, 
        79, 81, 84, 81, 79, 77, 79, 74, 77, 0,            60, 62, 65, 67, 65, 62, 60, 58, 60, 60, 0,    
        77, 79, 81, 84, 81, 79, 77, 74, 77, 77, 77, 0, 
    ] @=> int melody[];

    // 旋律2
    melody @=> int melody2[];
      
    // 節奏
    [   .25, .25, .25, .25, .75, .25, .25, .25, .25, .25, .75, .25,     .25, .25, .25, .25, .75, .25, .25, .25, .25, .25, .75, .25,
        1.0,  .5, .25, .25,  .5, .25, .25,  .5,  .5,                     .5,  .5, .75, .25,  .5,  .5, .25, .25, .25, .25,
        .25, .25, .25, .25, .75, .25,  .5,  .5,  .5,  .5,               1.0, .25, .25, .25, .25,  .5, .25, .25,  .8,  .2,
         .5,  .5, .25,  .5, .25,  .5,  .5, .25, .25,  .4,  .1,          .25, .25, .25, .25, .75, .25,  .5,  .5, 1.0,
        .25, .25,  .5,  .5,  .5, .25, .25,  .5,  .5, .25, .25, 1.0,     .25, .25, .25, .75,  .5, .25, .25,  .5,  .5, .25, .75, 0.5, 
        1.0,  .5,  .5,  .5,  .5, .25, .25,  .5, 1.0, 0.5,                .5,  .5,  .5,  .5, .25, .25,  .5,  .5,  .5,  .5, 1.0,     
        .25, .25, .25, .25, .75, .25,  .5,  .5,  .5,  .5, .75,.25, 
    ] @=> float beats[];


    TriOsc melodyOsc   => ADSR melodyEnv   => NRev melodyRve   => dac;    // 設定_旋律1
    SinOsc melody_2Osc => ADSR melody_2Env => NRev melody_2Rve => dac;    // 設定_旋律2

    0.15 => melodyRve.mix;                          //回音_旋律1
    0.05 => melody_2Rve.mix;                        //回音_旋律2
    
    for (0 => int i; i < melody.cap(); i++)
    {       
        0.5 * gainControl_Melody => melodyOsc.gain;
        0.2 * gainControl_Melody => melody_2Osc.gain;
        -7 + freqControl => int melodyOffset;

        if (melody[i]) 
        {
            Std.mtof(melody[i] + melodyOffset) => melodyOsc.freq;
            ((beats[i]/6)::second , (beats[i]/2)::second , 0.0 , 300::ms) => melodyEnv.set;   //根據音符長度，改變ADSR參數
            1 => melodyEnv.keyOn;
        }

        if (melody2[i]) 
        {
            Std.mtof(melody2[i] + 12 + melodyOffset) => melody_2Osc.freq;
            ((beats[i]/6)::second , (beats[i]/2)::second , 0.0 , 300::ms) => melody_2Env.set;  //根據音符長度，改變ADSR參數
            1 => melody_2Env.keyOn;
        }

        // 兩個聲部共用同一個拍子長度，在這一拍結束後才推進到下一個音
        beats[i] * valueToTranslateSpeed::second => now;
    }
}


// 節奏 =====================================================================================================================
fun void drum(){
    Noise noise => BPF filter => ADSR snareEnv => dac;

    300 => filter.freq;                 // 濾波器頻率
    1.0 => filter.Q;                    // 濾波器 Q 值
    (20::ms, 80::ms, 0.0, 2000::ms) => snareEnv.set; //// ADSR音符始末

    
    [
        1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
        1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0,
        1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 
        1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 0, 1,
        1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 0, 1,
        0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 
        1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1,
        1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1,
        0, 1, 0, 1, 1, 0, 1, 1, 
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    ] @=> int melodw[];

    [
        0.5, 0.25, 0.25, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.25, 0.25,
        0.125, 0.125, 0.125, 0.125, 0.5, 0.125, 0.125, 0.125, 0.125, 0.5, 0.5, 0.125, 0.125, 0.25, 0.25, 0.25, 0.25, 0.25,
        0.5, 0.25, 0.25, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.25, 0.25,
        0.125, 0.125, 0.125, 0.125, 0.5, 0.125, 0.125, 0.125, 0.125, 0.5, 0.5, 0.125, 0.125, 0.25, 0.25, 0.25, 0.25, 0.25,
        0.5, 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
        0.5, 0.125, 0.125, 0.125, 0.125, 0.5, 0.5, 2.0/9, 2.0/9, 2.0/9, 2.0/9, 2.0/9, 2.0/9, 2.0/9, 2.0/9, 2.0/9,
        0.5, 0.25,0.25,0.25,0.25,0.5, 1.0, 0.5, 0.125, 0.125, 0.125, 0.125,
        0.25, 0.25, 0.25, 0.25, 0.5, 0.5, 0.25, 0.25, 0.25, 0.25, 1.0,
        0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.5,
        0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1.0,
        2.0/3, 2.0/3, 2.0/3, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
        0.5, 0.5, 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.5,
        0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.5, 0.5,
        0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1.0,
        1.0, 0.25, 0.25, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5,
        0.5, 0.125, 0.125, 0.125, 0.125, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1.0,
        0.25, 0.25, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.25, 0.25, 0.5,
        0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 2.0/6, 2.0/6, 2.0/6, 2.0/6, 2.0/6, 2.0/12, 2.0/12,
        1.0, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5,
        0.5, 0.5, 0.5, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.5, 0.5, 
        0.5, 0.5, 0.5, 0.5, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 1.0 ,0.25,
        0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.5, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25,
        0.25, 0.25, 0.25, 0.25, 0.5 ,0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 
        0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.5, 0.5, 0.5, 0.5, 0.25, 0.25, 0.25, 0.25, 
        1.0, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1.0, 
        0.5, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 
        2.0, 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 
        0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
        0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.5, 1.0,0.25, 1.0,
    ] @=> float beatsw[];
    

    while(true){
        
        for (0 => int i; i < melodw.cap(); i++)
        {
            beatsw[i] * (0.5 * valueToTranslateSpeed::second) => dur noteDur; // 每個計算節奏
            Math.random2f(0.2,0.5)*gainControl_Beat => noise.gain;          //隨機音量

            if (melodw[i] == 1) 
            {
                1 => snareEnv.keyOn;
                noteDur => now;
                1 => snareEnv.keyOff;
            }
            else 
            {
                1 => snareEnv.keyOff;
                noteDur => now;
            }
        }
    }
}

// 隨機節奏 =====================================================================================================================
fun void playRandomSound(){
    TriOsc randomOsc => ADSR randomEnv => Pan2 randomPan => dac;
    
    1.0 => randomPan.pan;            // 設定左右聲道比例初始數值
    
    while(true)
    {
        Std.mtof(Math.random2(30, 50)) => randomOsc.freq;       // rendom頻率
        Math.random2f(0.01, 1.0)::second => dur randomDecay;    // rendomADSR收尾長度
        Math.random2f(-1.0, 1.0) => randomPan.pan;              // rendom左右聲道
        Math.random2f(0.2, 0.3) => randomOsc.gain;              // rendom音量
        (50::ms, randomDecay, 0.0, 100::ms) => randomEnv.set;  // // ADSR音符始末
        1 => randomEnv.keyOn;
        
        currentBeat() => now;
    }
}


// bell =====================================================================================================================
fun void bell(){
    Shakers bells => ADSR envelop => NRev rve1 => dac; //設定

    15 => bells.preset;         // 設定音色編號
    0.15 => rve1.mix;           // 回聲
    
    (currentBeat()/3, currentBeat()/4, 0.0, 1::ms) => envelop.set;  // ADSR音符始末

    while(true)
    {
        1.0 => float fadeVol; 

        // 搖動過程 (總共 20 次，每次 0.125 秒，共耗時 2.5 秒)
        for(0 => int i; i < 20; i++)
        {
            fadeVol => bells.gain;
            Math.random2f(0.5, 1.0) * fadeVol => bells.energy;
            1 => bells.noteOn;
            1 => envelop.keyOn;
            fadeVol - 0.05 => fadeVol;
            
            0.125::second => now; 
        }

        // 殘響收尾與時間對齊：
        // 兩小節在 120 BPM 下總共是 4.0 秒。
        // 上面搖動已經過了 2.5 秒，所以這裡再等待 1.5 秒，剛好滿兩小節再進入下一次循環！
        1.5::second => now;
    }
}


// wave =====================================================================================================================
fun void wave(){

    Noise waveNoise => LPF waveFilter => NRev waveRev => dac; // 設定

    0.03 => waveNoise.gain;        // 初始音量
    0.2 => waveRev.mix;            // 初始回聲
    0.1 => waveFilter.Q;           // 濾波器 Q 值

    SinOsc lfo => blackhole;       // 建立一個LOF物件
    0.1 => lfo.freq;               // 頻率越小，海浪來回的速度越慢

    while(true)
    {
        (lfo.last() + 1.0) * 500.0 + 200.0 => waveFilter.freq; // 頻率起伏
        (lfo.last() + 0.5) * 0.1 => waveNoise.gain;            // 音量起伏
        200::ms => now;    // rerender
    }

}


// baseDrum =====================================================================================================================
fun void bassDrum(){
    SinOsc bdOsc => ADSR bdEnv => dac; // 設定
    
    0.34 => bdOsc.gain;                // 音量
    100 => bdOsc.freq;                 // 頻率
    (50::ms, 1000::ms, 0.0, 300::ms) => bdEnv.set; // ADSR音符始末

    while(true)
    {
        for(0 => int i; i < 4; i++)
        {
            1 => bdEnv.keyOn;
            2.0 * valueToTranslateSpeed::second => now;
        }
    }
}


// play =====================================================================================================================
spork ~ bassDrum();
spork ~ wave();
spork ~ bell();
spork ~ drum();
spork ~ playRandomSound();
spork ~ playChords();
while(true){ melod();}
