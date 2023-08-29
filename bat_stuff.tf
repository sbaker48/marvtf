/def -i cer = /def -n1 -F -t'You perform the ceremony.' cer_do = /repeat -0:00:02 1 %{*}%;use ceremony
/def -i focus = /def -n1 -F -t'A vision of a single drop of blood, silently falling in darkness, fills your' focus_do = /repeat -0:00:02 1 %{*}%;use focus
/def -i -F -t'You fail to focus enough.' refocus = /repeat -0:00:02 1 use focus

/def -i -F -t'You awaken from your short rest, and feel slightly better.' camp0 = /trigger CAMPDONE
/def -i -F -t'Something disturbs you and you cannot concentrate any longer.' med0 = /trigger MEDDONE

/def -i -F -t'* <yellow glow>' glow_fw = /substitute -p %* @{Cyellow}[FW]@{n}
/def -i -F -t'* <orange glow>' glow_r_fw = /substitute -p %* @{Cyellow}[FW]@{n}
/def -i -F -t'* <blue glow>' glow_prot = /substitute -p %* @{Cblue}[PROT]@{n}
/def -i -F -t'* <purple glow>' glow_r_prot = /substitute -p %* @{Cblue}[PROT]@{n}
/def -i -F -t'* <green glow>' glow_fw_prot = /substitute -p %* @{Cyellow}[FW]@{n} @{Cblue}[PROT]@{n}
/def -i -F -t'* <white glow>' glow_r_fw_prot = /substitute -p %* @{Cyellow}[FW]@{n} @{Cblue}[PROT]@{n}

