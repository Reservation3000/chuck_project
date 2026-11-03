import { UseMySelfslider } from './hook.jsx'
import { ChuckPlayer , GetChuck } from './pages/chuck.jsx'
import { useState } from 'react';
import './App.css'


async function handleFloatChange(value, divisor, target) {
  const chuck = await GetChuck();
  const number = value / divisor;

  chuck.setFloat(target, number);
}

async function handleFreqChange(value) {
  const chuck = await GetChuck();
  const freqValue = -12 + (value / 100) * 24;

  chuck.setInt('freqControl', Math.round(freqValue));
}


function App() {

  const [gain, setGain] = useState(100);
  const [bpm, setBpm]   = useState(50);
  const [freq, setFreq] = useState(50);
  const [gainBeat, setGainBeat] = useState(50);

  return(
    <div className="app">

        <ChuckPlayer/>



      <div className="controlPanel">
        <UseMySelfslider
          color1="#eae5c6"
          color2="#565756"
          text="GAIN_MELODY"
          value={gain}
          setValue={setGain}
          onChange={(value) => ( handleFloatChange(value, 50, 'gainControl_Melody'))}
      />

      <UseMySelfslider
          color1="#a6dbf7"
          color2="#565756"
          text="FREQ"
          value={freq}
          setValue={setFreq}
          onChange={handleFreqChange}
      />

      <UseMySelfslider
          color1="#d3f9b3"
          color2="#565756"
          text="BPM"
          value={bpm}
          setValue={setBpm}
          onChange={async (value) => {
            const chuck = await GetChuck();
            const speed = 0.25 + (value / 100) * 1.75;

            chuck.setFloat('valueToTranslateSpeed', speed);
          }}
      />

      <UseMySelfslider
          color1="#f7a6c5"
          color2="#565756"
          text="GAIN_BEAT"
          value={gainBeat}
          setValue={setGainBeat}
          onChange={(value) => (
            handleFloatChange(value, 50, 'gainControl_Beat')
          )}
      />
      </div>

    </div>
  );
}

export default App
