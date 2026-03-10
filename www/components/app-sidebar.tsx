import * as React from "react"
import { NavMain } from "@/components/nav-main"
import { NavUser } from "@/components/nav-user"
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarHeader,
  SidebarMenuButton,
  SidebarRail,
} from "@/components/ui/sidebar"
import { $platformInfo, $userInfo } from "@/store/user"
import { useStore } from "@nanostores/react"
import { TbBuildingTunnel } from "react-icons/tb"
import { RegisterAndLogin } from "./header"
import { useRouter } from "next/navigation"
import { useQuery } from "@tanstack/react-query"
import { getPlatformInfo } from "@/api/platform"
import { getNavItems } from '@/config/nav'
import { useTranslation } from 'react-i18next'

export interface AppSidebarProps extends React.ComponentProps<typeof Sidebar> {
  children?: React.ReactNode
  footer?: React.ReactNode
}

export function AppSidebar({ ...props }: AppSidebarProps) {
  const router = useRouter()
  const { t } = useTranslation()
  const userInfo = useStore($userInfo)
  const { data: platformInfo } = useQuery({
    queryKey: ['platformInfo'],
    queryFn: getPlatformInfo,
  })

  React.useEffect(() => {
    $platformInfo.set(platformInfo)
  }, [platformInfo])

  return (
    <Sidebar collapsible="icon" {...props} className="glass-sidebar glass-sidebar-dark">
      <SidebarHeader>
        <SidebarMenuButton
          size="lg"
          className="data-[state=open]:bg-blue-500/10 data-[state=open]:text-blue-600 hover:bg-blue-500/10 transition-all"
          onClick={() => router.push("/")}
        >
          <div className="flex aspect-square size-8 items-center justify-center rounded-lg bg-gradient-to-br from-blue-500 to-cyan-500 text-white shadow-lg">
            <TbBuildingTunnel className="size-4" />
          </div>
          <div className="grid flex-1 text-left text-sm leading-tight">
            <span className="truncate font-bold bg-gradient-to-r from-blue-600 to-cyan-600 bg-clip-text text-transparent">
              {t('app.title')}
            </span>
            <span className="truncate text-xs text-blue-500/70">{t('app.subtitle')}</span>
          </div>
        </SidebarMenuButton>
        <NavMain items={getNavItems(t)} />
      </SidebarHeader>
      <SidebarContent>
        {props.children}
      </SidebarContent>
      <SidebarFooter>
        {props.footer}
        <div className="flex w-full flex-row group-data-[collapsible=icon]:flex-col-reverse gap-2 justify-between">
          {userInfo && <NavUser user={userInfo} />}
          {!userInfo && <RegisterAndLogin />}
        </div>
      </SidebarFooter>
      <SidebarRail />
    </Sidebar>
  )
}
