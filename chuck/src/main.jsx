import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { ConfigProvider } from 'antd';
import './index.css'
import App from './App.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <ConfigProvider
      theme={{
        token: {
          // Ant Design 全域主色
          colorPrimary: '#2eb6ff',
        },
        components: {
          Select: {
            // Select 下拉箭頭與清除圖示的顏色
            colorTextQuaternary: '#2eb6ff',
          },
          Slider: {
            // 滑桿未填滿區域的底色
            railBg: '#4b5546',
            // 滑鼠移到未填滿區域時的底色
            railHoverBg: '#4b5546',
            // 滑桿已填滿區域的底色
            trackBg: '#2eb6ff',
            // 滑鼠移到已填滿區域時的底色
            trackHoverBg: '#2eb6ff',
            // 滑桿控制點的邊框顏色
            handleColor: '#2eb6ff',
            // 拖曳控制點時的邊框顏色
            handleActiveColor: '#bed1be',
          },
        },
      }}
    >
      <App />
    </ConfigProvider>
  </StrictMode>,
)
