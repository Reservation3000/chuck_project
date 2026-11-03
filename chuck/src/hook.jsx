import './hook.css';

export const UseMySelfslider = ({ color1 , color2 , text , value , setValue , onChange }) => {

    const handleMouseMove = (e) => {
        const rect = e.currentTarget.getBoundingClientRect();
        const progress = ((e.clientY - rect.top) / rect.height)*100;

        setValue(progress);
        onChange?.(progress);
    };  

    return(
        <div className="container"
             style={{ "--progress": `${value}%` , 
                      "--color1": color1 , 
                      "--color2": color2 
                    }}
             onMouseMove={handleMouseMove}
             onMouseLeave={() => setValue(prev => prev)}
        >
            <p>{text}</p>
        </div>
    );
}