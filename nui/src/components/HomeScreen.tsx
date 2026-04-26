import { usePhoneStore, AppId } from '../store/phoneStore';
import { Phone, MessageCircle, Wallet, Camera, Instagram, Heart, Globe, Settings } from 'lucide-react';

const APPS = [
  { id: 'instagram', name: 'Instagram', color: 'bg-gradient-to-tr from-yellow-400 via-pink-500 to-purple-500', icon: Instagram },
  { id: 'tinder', name: 'Tinder', color: 'bg-gradient-to-tr from-pink-500 to-orange-400', icon: Heart },
  { id: 'tor', name: 'Onion', color: 'bg-zinc-800', icon: Globe },
  { id: 'settings', name: 'Ajustes', color: 'bg-zinc-500', icon: Settings },
] as const;

const DOCK_APPS = [
  { id: 'phone', color: 'bg-green-500', icon: Phone },
  { id: 'messages', color: 'bg-green-400', icon: MessageCircle },
  { id: 'bank', color: 'bg-blue-500', icon: Wallet },
  { id: 'camera', color: 'bg-zinc-200 text-black', icon: Camera },
] as const;

export default function HomeScreen() {
  const openApp = usePhoneStore((s) => s.openApp);

  return (
    <div className="absolute inset-0 bg-gradient-to-b from-indigo-900 to-black p-6 pt-16 flex flex-col">
      <div className="grid grid-cols-4 gap-y-6 gap-x-4 place-items-center mt-4">
        {APPS.map((app) => (
          <div key={app.id} className="flex flex-col items-center gap-1 cursor-pointer" onClick={() => openApp(app.id as AppId)}>
            <div className={`w-[60px] h-[60px] ${app.color} rounded-[16px] flex items-center justify-center shadow-sm`}>
              <app.icon size={32} className={app.color.includes('text-black') ? '' : 'text-white'} strokeWidth={1.5} />
            </div>
            <span className="text-[11px] font-medium tracking-wide text-white drop-shadow-md">{app.name}</span>
          </div>
        ))}
      </div>

      <div className="mt-auto mb-4 bg-white/20 backdrop-blur-[30px] rounded-[32px] p-4 flex justify-between mx-1 shadow-lg">
        {DOCK_APPS.map((app) => (
          <div key={app.id} className={`w-[60px] h-[60px] ${app.color} rounded-[16px] flex items-center justify-center cursor-pointer shadow-sm`} onClick={() => openApp(app.id as AppId)}>
            <app.icon size={32} className={app.color.includes('text-black') ? '' : 'text-white'} strokeWidth={1.5} />
          </div>
        ))}
      </div>
    </div>
  );
}