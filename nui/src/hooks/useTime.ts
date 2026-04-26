import { useState, useEffect } from 'react';

export function useTime() {
  const [time, setTime] = useState(new Date());

  useEffect(() => {
    const timer = setInterval(() => setTime(new Date()), 1000);
    return () => clearInterval(timer);
  }, []);

  return {
    hours: time.getHours().toString().padStart(2, '0'),
    minutes: time.getMinutes().toString().padStart(2, '0'),
    date: time.toLocaleDateString('pt-BR', { weekday: 'long', day: 'numeric', month: 'long' })
  };
}