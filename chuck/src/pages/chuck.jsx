import { Chuck } from 'webchuck';
import { Slider } from 'antd';
import { useState, useRef } from 'react';
import ReactPlayer from 'react-player';

const soundCode = `
// 小提琴
Bowed violin => dac;

// 只需要保留音量的全域變數
global float gVolume;
global Event gFinished;

gVolume;

// 修正：直接設定 violin 的參數
0.43 => violin.bowPressure;
0.5 => violin.bowPosition;
0.15 => violin.vibratoFreq;  
0.02 => violin.vibratoGain; 

[   77, 68,             // 第1小節
    73, 77, 77,         // 第2小節
    75, 78, 77, 72,     // 第3小節
    73                  // 第4-5小節 (綁定長音)
] @=> int melody[];

[
    3.0, 1.0,           
    1.0, 1.0, 2.0,      
    1.0, 1.0, 1.0, 1.0, 
    6.0                 
] @=> float beats[];

0.5::second => dur beat;  // 一拍 0.5 秒

fun void updateParams() {
    while(true) {
        gVolume => violin.volume;
        10::ms => now; 
    }
}
spork ~ updateParams();

for( 0 => int i; i < melody.cap(); i++ )
{
    Std.mtof(melody[i]) => violin.freq;  
    0.8 => violin.noteOn;                
    beats[i] * beat => dur noteDur;      
    noteDur - 0.05::second => now;       

    1.0 => violin.noteOff;               
    0.05::second => now;
}

gFinished.broadcast();
`;

let chuckPromise;

function getChuck() {
  if (!chuckPromise) { 
      chuckPromise = Chuck.init([]); 
  }
  return chuckPromise;
}

export function ChuckPlayer() {
  const [isplay, setIsplay] = useState(false);
  const [volume, setVolume] = useState(0);
  const shredRef = useRef(null); // 用來記錄 ChucK 的執行緒 ID

async function togglePlay() {
      if (!isplay) {
          // 【Play 的狀態】
          // 1. 先立刻更新 React 狀態，讓影片馬上開始播！(避免被瀏覽器阻擋)
          setIsplay(true);
          
          // 2. 接著再處理 ChucK 的音效載入
          const chuck = await getChuck();
          if (chuck.context.state === 'suspended') { 
              await chuck.context.resume();
          }
          const id = await chuck.runCode(soundCode);
          shredRef.current = id;
          chuck.listenForEventOnce('gFinished', () => {
              shredRef.current = null;
              setIsplay(false);
          });
      } else {
          // 【Stop 的狀態】
          // 1. 立刻暫停影片
          setIsplay(false);
          
          // 2. 停止 ChucK 音效
          const chuck = await getChuck();
          if (shredRef.current !== null) {
              chuck.removeShred(shredRef.current);
              shredRef.current = null;
          }
      }
  }

  async function handleVolumeChange(value) {
      setVolume(value);
      const chuck = await getChuck();
      chuck.setFloat('gVolume', value);
  }

  return (
    <div className="chuck_Player">
        <div className="chuck_Container" onClick={togglePlay}>
        <h1>Chuck?¿?¿</h1>
        
        <div
          className="slider_Control"
          onClick={(event) => event.stopPropagation()}
          onPointerDown={(event) => event.stopPropagation()}
        >
            <Slider 
              min={0} 
              max={1} 
              step={0.01} 
              value={volume}
              disabled={!isplay}
              onChange={handleVolumeChange}
              style={{width:"100px"}}
            />
        </div>
        </div>
        
        <div
          className="video_Container"
          style={{ '--mask-opacity': 1 - volume }}
        >
        <ReactPlayer
          src="/basevedio.mp4"
          playing={isplay}
          loop
          muted
          width="100%"
          height="100%"
        />
        </div>
    </div>
  );
}