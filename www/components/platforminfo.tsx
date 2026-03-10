import { useQuery } from '@tanstack/react-query'
import { GlassCard } from '@/components/ui/glass-card'
import { TbDeviceHeartMonitor, TbEngine, TbEngineOff, TbServer2, TbServerBolt, TbServerOff } from 'react-icons/tb'
import { useEffect } from 'react'
import { $platformInfo } from '@/store/user'
import { getPlatformInfo } from '@/api/platform'
import { useTranslation } from 'react-i18next';

export default function PlatformInfo() {
  const { t } = useTranslation();
  const platformInfo = useQuery({
    queryKey: ['platformInfo'],
    queryFn: getPlatformInfo,
  })
  useEffect(() => {
    $platformInfo.set(platformInfo.data)
  }, [platformInfo])
  return (
    <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
      <GlassCard variant="hover" className="group">
        <div className="flex justify-between items-start mb-4">
          <h3 className="text-sm font-semibold text-blue-900 dark:text-blue-100">{t('platform.configuredServers')}</h3>
          <TbServerBolt className="text-2xl text-blue-500 group-hover:scale-110 transition-transform" />
        </div>
        <div className="text-3xl font-bold bg-gradient-to-r from-blue-600 to-cyan-600 bg-clip-text text-transparent">
          {platformInfo.data?.configuredServerCount} {t('platform.unit')}
        </div>
        <p className="text-xs text-muted-foreground mt-2">{t('platform.menuHint')}</p>
      </GlassCard>
      <GlassCard variant="hover" className="group">
        <div className="flex justify-between items-start mb-4">
          <h3 className="text-sm font-semibold text-blue-900 dark:text-blue-100">{t('platform.configuredClients')}</h3>
          <TbEngine className="text-2xl text-cyan-500 group-hover:scale-110 transition-transform" />
        </div>
        <div className="text-3xl font-bold bg-gradient-to-r from-cyan-600 to-blue-600 bg-clip-text text-transparent">
          {platformInfo.data?.configuredClientCount} {t('platform.unit')}
        </div>
        <p className="text-xs text-muted-foreground mt-2">{t('platform.menuHint')}</p>
      </GlassCard>
      <GlassCard variant="hover" className="group">
        <div className="flex justify-between items-start mb-4">
          <h3 className="text-sm font-semibold text-blue-900 dark:text-blue-100">{t('platform.unconfiguredServers')}</h3>
          <TbServerOff className="text-2xl text-slate-400 group-hover:scale-110 transition-transform" />
        </div>
        <div className="text-3xl font-bold bg-gradient-to-r from-slate-600 to-slate-400 bg-clip-text text-transparent">
          {platformInfo.data?.unconfiguredServerCount} {t('platform.unit')}
        </div>
        <p className="text-xs text-muted-foreground mt-2">{t('platform.menuHint')}</p>
      </GlassCard>
      <GlassCard variant="hover" className="group">
        <div className="flex justify-between items-start mb-4">
          <h3 className="text-sm font-semibold text-blue-900 dark:text-blue-100">{t('platform.unconfiguredClients')}</h3>
          <TbEngineOff className="text-2xl text-slate-400 group-hover:scale-110 transition-transform" />
        </div>
        <div className="text-3xl font-bold bg-gradient-to-r from-slate-600 to-slate-400 bg-clip-text text-transparent">
          {platformInfo.data?.unconfiguredClientCount} {t('platform.unit')}
        </div>
        <p className="text-xs text-muted-foreground mt-2">{t('platform.menuHint')}</p>
      </GlassCard>
      <GlassCard variant="hover" className="group">
        <div className="flex justify-between items-start mb-4">
          <h3 className="text-sm font-semibold text-blue-900 dark:text-blue-100">{t('platform.totalServers')}</h3>
          <TbServer2 className="text-2xl text-blue-600 group-hover:scale-110 transition-transform" />
        </div>
        <div className="text-3xl font-bold bg-gradient-to-r from-blue-700 to-indigo-600 bg-clip-text text-transparent">
          {platformInfo.data?.totalServerCount} {t('platform.unit')}
        </div>
        <p className="text-xs text-muted-foreground mt-2">{t('platform.menuHint')}</p>
      </GlassCard>
      <GlassCard variant="hover" className="group">
        <div className="flex justify-between items-start mb-4">
          <h3 className="text-sm font-semibold text-blue-900 dark:text-blue-100">{t('platform.totalClients')}</h3>
          <TbDeviceHeartMonitor className="text-2xl text-cyan-600 group-hover:scale-110 transition-transform" />
        </div>
        <div className="text-3xl font-bold bg-gradient-to-r from-cyan-700 to-teal-600 bg-clip-text text-transparent">
          {platformInfo.data?.totalClientCount} {t('platform.unit')}
        </div>
        <p className="text-xs text-muted-foreground mt-2">{t('platform.menuHint')}</p>
      </GlassCard>
    </div>
  )
}
