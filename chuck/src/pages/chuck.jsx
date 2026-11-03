import { useState } from 'react';
import { Chuck } from 'webchuck';
import {
  PlayCircleFilled,
} from '@ant-design/icons';
import chuckProgram from '../chuck/chuckProgram.ck?raw';

let chuckPromise;

export function GetChuck() {
  if (!chuckPromise) {
    chuckPromise = Chuck.init([]);
  }

  return chuckPromise;
}

export const ChuckPlayer = () => {
  const [isPlaying, setIsPlaying] = useState(false);

  const handlePlay = async () => {
    if (isPlaying) {
      return;
    }

    try {
      setIsPlaying(true);
      const chuck = await GetChuck();

      if (chuck.context.state === 'suspended') {
        await chuck.context.resume();
      }

      await chuck.runCode(chuckProgram);
    } catch (error) {
      setIsPlaying(false);
      console.error('播放 ChucK 程式失敗:', error);
    }
  };

  return (
      <div className="musicPlayer" onClick={handlePlay}>
        {isPlaying ? "CHUCK???" : "喵"}
      </div>
  );
};