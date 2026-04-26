import { useTime } from '../hooks/useTime';
import { usePhoneStore } from '../store/phoneStore';
import { motion } from 'framer-motion';

export default function LockScreen() {
  const { hours, minutes, date } = useTime();
  const unlock = usePhoneStore((s) => s.unlock);

  return (
    <motion.div
      className="absolute inset-0 bg-gradient-to-b from-zinc-800 to-black flex flex-col items-center pt-24 z-40"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ y: '-100%', opacity: 0 }}
      transition={{ duration: 0.4, ease: [0.32, 0.72, 0, 1] }}
      drag="y"
      dragConstraints={{ top: 0, bottom: 0 }}
      onDragEnd={(_, info) => { 
        if (info.offset.y < -50) unlock(); // Desbloqueia ao jogar para cima
      }}
    >
      <h2 className="text-[22px] font-medium text-white/80 capitalize">{date}</h2>
      <h1 className="text-[96px] font-thin leading-none tracking-tighter mt-[-10px] select-none pointer-events-none">
        {hours}:{minutes}
      </h1>
      
      <div className="mt-auto mb-12 flex flex-col items-center animate-pulse opacity-60">
        <span className="text-xs font-medium">Deslize para cima para abrir</span>
      </div>
    </motion.div>
  );
}