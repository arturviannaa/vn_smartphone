import { useTime } from '../hooks/useTime';
import { Battery, Wifi, SignalHigh } from 'lucide-react';
import DynamicIsland from './DynamicIsland';

export default function StatusBar() {
  const { hours, minutes } = useTime();

  return (
    <div className="absolute top-0 w-full h-[44px] flex items-center justify-between px-6 z-50 pointer-events-none">
      <div className="w-1/3 text-[15px] font-semibold tracking-tight mt-1">{hours}:{minutes}</div>
      <div className="w-1/3 flex justify-center mt-1">
        <DynamicIsland />
      </div>
      <div className="w-1/3 flex justify-end items-center gap-1.5 mt-1">
        <SignalHigh size={16} strokeWidth={2.5} />
        <Wifi size={16} strokeWidth={2.5} />
        <Battery size={20} strokeWidth={2} className="opacity-90" />
      </div>
    </div>
  );
}