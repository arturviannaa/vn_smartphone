import { usePhoneStore } from '../store/phoneStore';

export default function HomeIndicator() {
  const { closeApp, isLocked } = usePhoneStore();
  
  if (isLocked) return null;

  return (
    <div
      className="absolute bottom-2 w-full flex justify-center pb-2 pt-4 cursor-pointer z-50"
      onClick={closeApp}
    >
      <div className="w-[140px] h-[5px] bg-white/80 rounded-full" />
    </div>
  );
}