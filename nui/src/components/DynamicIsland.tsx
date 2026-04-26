import { motion } from 'framer-motion';

export default function DynamicIsland() {
  return (
    <motion.div
      layout
      // O border-white/15 cria a linha fina
      // O shadow cria o glow ("brilho") ao redor
      className="bg-black w-[126px] h-[37px] rounded-full pointer-events-auto border border-white/15 shadow-[0_0_15px_rgba(255,255,255,0.15)] z-[60]"
    />
  );
}