-- ============================================================
-- REMOTE VD — Daftar Remote Violence District (Dari RemoteSpy + Explorer)
-- Semua remote sudah di-unique (tidak ada double)
-- Setiap remote disertai keterangan kegunaan & cara pakai
-- ============================================================

-- ⚠️ Game VD MEKANIK:
--   HP < 50  = KNOCKED (bisa di-carry, di-hook killer)
--   HP 50-100 = ALIVE (normal, bisa jalan/tembak)

-- ═══════════════════════════════════════════════════════════
-- SECTION 1: ATTACKS
-- ═══════════════════════════════════════════════════════════

-- Remotes.Attacks.AfterAttack
-- Kegunaan: Dipanggil setelah serangan selesai (post-attack cleanup)
-- Kemungkinan argumen: tidak ada atau (victim)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("AfterAttack"):FireServer()

-- Remotes.Attacks.BasicAttack
-- Kegunaan: Serangan dasar killer ke survivor
-- Argumen: (victimPlayer atau targetPart)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack"):FireServer()

-- Remotes.Attacks.Lunge
-- Kegunaan: Serangan lunge (lompat + serang) killer
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("Lunge"):FireServer()

-- Remotes.Attacks.LungeDetect
-- Kegunaan: Deteksi hit lunge attack (apakah lunge mengenai target)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("LungeDetect"):FireServer()

-- Remotes.Attacks.Trail Event
-- Kegunaan: Visual trail effect saat serangan (efek jejak senjata)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("Trail Event"):FireServer()

-- Remotes.Attacks.hit
-- Kegunaan: Konfirmasi hit (serangan mengenai target)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("hit"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 2: CARRY / HOOK
-- ═══════════════════════════════════════════════════════════

-- Remotes.Carry.PlayAnimation
-- Kegunaan: Mainkan animasi carry/hook
-- Argumen: (animName atau animId)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("PlayAnimation"):FireServer()

-- Remotes.Carry.CarryAnim
-- Kegunaan: Animasi carry survivor (killer mengangkat survivor)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("CarryAnim"):FireServer()

-- Remotes.Carry.CarrySurvivorEvent
-- Kegunaan: Mulai carry survivor (killer mengangkat yang knocked)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("CarrySurvivorEvent"):FireServer()

-- Remotes.Carry.DropSurvivorEvent
-- Kegunaan: Drop survivor yang sedang di-carry
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("DropSurvivorEvent"):FireServer()

-- Remotes.Carry.GetCarriedAnim
-- Kegunaan: Animasi saat sedang di-carry (dari sisi survivor)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("GetCarriedAnim"):FireServer()

-- Remotes.Carry.HookEvent
-- Kegunaan: Hook survivor ke tiang gantungan
-- Argumen: (HookPoint) — posisi hook
local args = { workspace:WaitForChild("Map"):WaitForChild("Hook"):WaitForChild("HookPoint") }
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("HookEvent"):FireServer(unpack(args))

-- Remotes.Carry.HookEventsucceess
-- Kegunaan: Konfirmasi hook berhasil (success callback)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("HookEventsucceess"):FireServer()

-- Remotes.Carry.HookPhase
-- Kegunaan: Fase hook (masuk/keluar dari hook)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("HookPhase"):FireServer()

-- Remotes.Carry.SelfUnHookEvent
-- Kegunaan: ✅ Lepas diri sendiri dari hook (self unhook!)
-- Argumen: (HookPoint) — posisi hook yang mau dilepas
local args = { workspace:WaitForChild("Map"):WaitForChild("Hook"):WaitForChild("HookPoint") }
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("SelfUnHookEvent"):FireServer(unpack(args))

-- Remotes.Carry.UnHookEvent
-- Kegunaan: Lepas dari hook (oleh player lain / umum)
-- Argumen: (HookPoint) — posisi hook yang mau dilepas
local args = { workspace:WaitForChild("Map"):WaitForChild("Hook"):WaitForChild("HookPoint") }
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("UnHookEvent"):FireServer(unpack(args))

-- ═══════════════════════════════════════════════════════════
-- SECTION 3: CHASE
-- ═══════════════════════════════════════════════════════════

-- Remotes.Chase.ChaseMusicEvent
-- Kegunaan: Mulai/stop musik chase (saat killer mengejar)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Chase"):WaitForChild("ChaseMusicEvent"):FireServer()

-- Remotes.Chase.Runevent
-- Kegunaan: Trigger event berlari/chase
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Chase"):WaitForChild("Runevent"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 4: COLLISION
-- ═══════════════════════════════════════════════════════════

-- ⭐ Remotes.Collision.EnableCollision
-- Kegunaan: ✅ RE-ENABLE COLLISION SETELAH KNOCK!
-- Saat player knock, game DISABLE collision player (bisa tembus dll)
-- Remote ini re-enable collision, WAJIB dikirim saat revive dari knock!
-- Tanpa remote ini, server masih anggap collision disabled = knock state masih aktif!
-- Ini yang game kirim PERTAMA saat revive dari knock (RemoteSpy urutan #1)
-- Tanpa argumen
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Collision"):WaitForChild("EnableCollision"):FireServer()

-- Remotes.Collision.DisableCollision
-- Kegunaan: Disable collision player (saat knock, game panggil ini)
-- ⚠️ JANGAN dipanggil manual! Ini untuk knock state
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Collision"):WaitForChild("DisableCollision"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 5: EXIT
-- ═══════════════════════════════════════════════════════════

-- Remotes.Exit.LeverAnim
-- Kegunaan: Animasi tarik tuas (exit gate lever)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Exit"):WaitForChild("LeverAnim"):FireServer()

-- Remotes.Exit.LeverEvent
-- Kegunaan: Aktifkan tuas exit gate
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Exit"):WaitForChild("LeverEvent"):FireServer()

-- Remotes.Exit.gate
-- Kegunaan: Buka/tutup exit gate
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Exit"):WaitForChild("gate"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 6: GAME (BANYAK REMOTE PENTING!)
-- ═══════════════════════════════════════════════════════════

-- ⭐⭐⭐ Remotes.Game.Apply Status
-- Kegunaan: ✅ APPLY STATUS KE PLAYER (injured, broken, exhausted, dll)
-- Mungkin bisa apply status "healed" atau "alive" untuk self-heal!
-- Argumen: kemungkinan (statusName, target) atau (statusName, duration, target)
-- PERLU REMOTESPY untuk tau argumen yang benar!
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("Apply Status"):FireServer()

-- ⭐⭐⭐ Remotes.Game.RemoveStatus
-- Kegunaan: ✅✅✅ HAPUS STATUS DARI PLAYER — INI MUNGKIN KUNCI SELF-HEAL!
-- Kalau "knocked" itu status, kita bisa HAPUS dengan remote ini!
-- Mungkin bisa hapus status "injured", "dying", "knocked", "broken", dll
-- Argumen: kemungkinan (statusName) atau (statusName, target)
-- PERLU REMOTESPY untuk tau argumen yang benar!
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("RemoveStatus"):FireServer()

-- Remotes.Game.EnableScript
-- Kegunaan: Enable script game (setelah loaded)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("EnableScript"):FireServer()

-- Remotes.Game.EndScreen Event
-- Kegunaan: Trigger end screen (tampilkan layar akhir match)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("EndScreen Event"):FireServer()

-- Remotes.Game.Equipitems
-- Kegunaan: Equip item ke player
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("Equipitems"):FireServer()

-- Remotes.Game.IdleRefresh Event
-- Kegunaan: Refresh idle state (anti-AFK?)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("IdleRefresh Event"):FireServer()

-- Remotes.Game.KillerMorph
-- Kegunaan: Morph player jadi killer (transform ke killer character)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("KillerMorph"):FireServer()

-- Remotes.Game.Loaded
-- Kegunaan: Konfirmasi client sudah loaded
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("Loaded"):FireServer()

-- Remotes.Game.Loadedevent
-- Kegunaan: Event setelah loaded (server-side loaded confirmation)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("Loadedevent"):FireServer()

-- Remotes.Game.ClassName
-- Kegunaan: Set/check class name (killer/survivor)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("ClassName"):FireServer()

-- Remotes.Game.Oneleft
-- Kegunaan: Trigger "one left" (1 survivor tersisa)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("Oneleft"):FireServer()

-- Remotes.Game.Oneleftbindable
-- Kegunaan: Bindable event untuk "one left" (client-side trigger)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("Oneleftbindable"):FireServer()

-- Remotes.Game.PlayerActionEvent
-- Kegunaan: Aksi player (interaksi, dsb)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("PlayerActionEvent"):FireServer()

-- Remotes.Game.ReplicateCharacterLook
-- Kegunaan: Update tampilan character ke semua player
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("ReplicateCharacterLook"):FireServer()

-- Remotes.Game.ResetEndscreenvals
-- Kegunaan: Reset nilai end screen
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("ResetEndscreenvals"):FireServer()

-- Remotes.Game.Reward Event
-- Kegunaan: Berikan reward ke player (gears, XP, dll)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("Reward Event"):FireServer()

-- Remotes.Game.Reward GearsEvent
-- Kegunaan: Berikan gears (currency) ke player
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("Reward GearsEvent"):FireServer()

-- Remotes.Game.RoundEnd
-- Kegunaan: Akhir ronde
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("RoundEnd"):FireServer()

-- Remotes.Game.Round End Event
-- Kegunaan: Event akhir ronde (mirror of RoundEnd)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("Round End Event"):FireServer()

-- Remotes.Game.Start
-- Kegunaan: Mulai match/ronde
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("Start"):FireServer()

-- Remotes.Game.Tween Settings Event
-- Kegunaan: Animasi tween untuk settings UI
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("Tween Settings Event"):FireServer()

-- Remotes.Game.UpdateCharacterLook
-- Kegunaan: Update tampilan character
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("UpdateCharacterLook"):FireServer()

-- Remotes.Game.cutscene
-- Kegunaan: Mulai cutscene
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("cutscene"):FireServer()

-- Remotes.Game.cutsceneEnd
-- Kegunaan: Akhir cutscene
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("cutsceneEnd"):FireServer()

-- Remotes.Game.cutsceneEnd2
-- Kegunaan: Akhir cutscene fase 2
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("cutsceneEnd2"):FireServer()

-- Remotes.Game.cutsceneEndwithownchar
-- Kegunaan: Akhir cutscene dengan character sendiri
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("cutsceneEndwithownchar"):FireServer()

-- Remotes.Game.deletespectatorgui
-- Kegunaan: Hapus spectator GUI (setelah mati/spectate)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("deletespectatorgui"):FireServer()

-- Remotes.Game.endgame
-- Kegunaan: Akhiri game
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("endgame"):FireServer()

-- Remotes.Game.endscreencutscene
-- Kegunaan: Cutscene layar akhir
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("endscreencutscene"):FireServer()

-- Remotes.Game.loadcharevent
-- Kegunaan: Load character (setelah pilih killer/survivor)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("loadcharevent"):FireServer()

-- Remotes.Game.loadvm
-- Kegunaan: Load VIP/voiceline manager
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("loadvm"):FireServer()

-- Remotes.Game.playvoiceline
-- Kegunaan: Mainkan voice line (killer/survivor dialog)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("playvoiceline"):FireServer()

-- Remotes.Game.shake
-- Kegunaan: Efek shake screen (gempa, impact, dll)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("shake"):FireServer()

-- Remotes.Game.showresults
-- Kegunaan: Tampilkan hasil match
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("showresults"):FireServer()

-- Remotes.Game.verifyscripts
-- Kegunaan: Verifikasi script sudah load dengan benar
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Game"):WaitForChild("verifyscripts"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 7: HEALING (PENTING!)
-- ═══════════════════════════════════════════════════════════

-- ⚠️ CATATAN PENTING DARI REMOTESPY:
-- Game VD KNOCK THRESHOLD: HP < 50 = KNOCKED, HP 50-100 = ALIVE
--
-- HealEvent(HRP, false) = Hanya bisa heal orang LAIN!
--   Server akan REJECT kalau HRP = HumanoidRootPart diri sendiri
--   false = heal (sembuhkan luka), true = revive (bangunkan dari knock)
-- Healing.Reset(Player) = ✅ Satu-satunya cara self-revive!
--   Kirim Player (bukan Character/HRP) untuk reset status diri sendiri
--   Reset = hapus knock state + restore HP ke 100 di SERVER
--
-- 2 SKENARIO HEAL (berbeda remote!):
--
-- SKENARIO A — REVIVE DARI KNOCK (HP < 50):
--   1. Collision.EnableCollision:FireServer() — ✅ WAJIB! Re-enable collision
--   2. EmoteHandler("StopEmote") — stop animasi sekarat
--   3. Healing.Reset(Player) — reset knock + restore HP
--
-- SKENARIO B — HEAL PARTIAL DAMAGE (HP 50-99):
--   1. ChangeAttribute("Crouchingserver", false) — hapus injured state
--   2. EmoteHandler("StopEmote") — stop animasi sekarat
--   3. Healing.Reset(Player) — reset state + restore HP

-- Remotes.Healing.DisplayBlood
-- Kegunaan: Tampilkan efek darah di screen (visual effect saat injured)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("DisplayBlood"):FireServer()

-- Remotes.Healing.HealAnim
-- Kegunaan: Mainkan animasi heal (orang yang heal)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("HealAnim"):FireServer()

-- Remotes.Healing.HealAnimRec
-- Kegunaan: Terima animasi heal (orang yang di-heal, receiver)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("HealAnimRec"):FireServer()

-- Remotes.Healing.HealEvent
-- Kegunaan: Heal/Revive PLAYER LAIN (bukan diri sendiri!)
-- Argumen: (TargetHumanoidRootPart, false/true)
--   false = sembuhkan luka biasa (HP naik)
--   true  = revive dari knocked/down
-- ⚠️ TIDAK BISA untuk diri sendiri — server reject kalau HRP milik sendiri!
local args = {
    game:GetService("Players"):WaitForChild("toya_133").Character:WaitForChild("HumanoidRootPart"),
    false
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("HealEvent"):FireServer(unpack(args))

-- ⭐ Remotes.Healing.Reset
-- Kegunaan: ✅ Reset status DIRI SENDIRI — bangun dari knocked/injured
-- Argumen: (Player) — kirim LocalPlayer, bukan Character!
-- Ini SATU-SATUNYA cara self-revive tanpa bantuan player lain
-- Reset = hapus knock state + restore HP ke 100 di SERVER
local args = {
    game:GetService("Players"):WaitForChild("Saycho_o")
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("Reset"):FireServer(unpack(args))

-- Remotes.Healing.SkillCheckEvent
-- Kegunaan: Mulai skill check healing (pop up skill check UI)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("SkillCheckEvent"):FireServer()

-- Remotes.Healing.SkillCheckFailEvent
-- Kegunaan: Skill check gagal (miss timing)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("SkillCheckFailEvent"):FireServer()

-- Remotes.Healing.SkillCheckResultEvent
-- Kegunaan: Kirim hasil skill check healing (auto-pass skill check)
-- Argumen: ("neutral", 0, TargetCharacter)
-- "neutral" = hasil netral/pass, 0 = nilai
-- Biasanya dipakai bersamaan dengan HealEvent atau Reset
local args = {
    "neutral",
    0,
    game:GetService("Players"):WaitForChild("toya_133").Character
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("SkillCheckResultEvent"):FireServer(unpack(args))

-- ⭐ Remotes.Healing.Stophealing
-- Kegunaan: ✅ Stop proses healing yang sedang berjalan
-- Mungkin perlu dipanggil sebelum mulai heal baru (reset heal state)
-- Tanpa argumen
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("Stophealing"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 8: KILLER PERKS
-- ═══════════════════════════════════════════════════════════

-- Remotes.KillerPerks.Abyssal Covenant.trigger
-- Kegunaan: Trigger perk Abyssal Covenant
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("KillerPerks"):WaitForChild("Abyssal Covenant"):WaitForChild("trigger"):FireServer()

-- Remotes.KillerPerks.Resentment Clinger.onstun
-- Kegunaan: Trigger perk Resentment Clinger saat stun
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("KillerPerks"):WaitForChild("Resentment Clinger"):WaitForChild("onstun"):FireServer()

-- Remotes.KillerPerks.Activatecdbindable
-- Kegunaan: Activate cooldown (bindable event)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("KillerPerks"):WaitForChild("Activatecdbindable"):FireServer()

-- Remotes.KillerPerks.Activatecdremote
-- Kegunaan: Activate cooldown remote (server-side)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("KillerPerks"):WaitForChild("Activatecdremote"):FireServer()

-- Remotes.KillerPerks.StackRemote
-- Kegunaan: Stack perk effect (tambah stack)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("KillerPerks"):WaitForChild("StackRemote"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 9: KILLERS
-- ═══════════════════════════════════════════════════════════

-- Remotes.Killers.Abysswalker.corrupt
-- Kegunaan: Abysswalker corrupt ability
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Abysswalker"):WaitForChild("corrupt"):FireServer()

-- Remotes.Killers.Abysswalker.visualize
-- Kegunaan: Abysswalker visualize ability
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Abysswalker"):WaitForChild("visualize"):FireServer()

-- Remotes.Killers.Hidden.M2
-- Kegunaan: Hidden killer M2 attack (secondary attack)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Hidden"):WaitForChild("M2"):FireServer()

-- Remotes.Killers.Hidden.endlag
-- Kegunaan: Hidden killer endlag (end of attack animation)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Hidden"):WaitForChild("endlag"):FireServer()

-- Remotes.Killers.Hidden.highlight
-- Kegunaan: Hidden killer highlight survivor
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Hidden"):WaitForChild("highlight"):FireServer()

-- Remotes.Killers.Hidden.preparem2
-- Kegunaan: Hidden killer prepare M2 (charge secondary attack)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Hidden"):WaitForChild("preparem2"):FireServer()

-- Remotes.Killers.Jason.LakeMist
-- Kegunaan: Jason killer Lake Mist ability
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Jason"):WaitForChild("LakeMist"):FireServer()

-- Remotes.Killers.Jason.Pursuit
-- Kegunaan: Jason killer Pursuit ability (chase mode)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Jason"):WaitForChild("Pursuit"):FireServer()

-- Remotes.Killers.Killer.ActivatePower
-- Kegunaan: Aktifkan killer power (ability utama)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Killer"):WaitForChild("ActivatePower"):FireServer()

-- Remotes.Killers.Killer.Cooldown Event
-- Kegunaan: Event cooldown killer power
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Killer"):WaitForChild("Cooldown Event"):FireServer()

-- Remotes.Killers.Killer.Deactivate
-- Kegunaan: Deactivate killer power
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Killer"):WaitForChild("Deactivate"):FireServer()

-- Remotes.Killers.Killer.Deactivatefromclient
-- Kegunaan: Deactivate killer power dari client
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Killer"):WaitForChild("Deactivatefromclient"):FireServer()

-- Remotes.Killers.Killer.FrenzyHitEvent
-- Kegunaan: Frenzy hit event (killer frenzy mode attack)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Killer"):WaitForChild("FrenzyHitEvent"):FireServer()

-- Remotes.Killers.Killer.IdleRefresh Event
-- Kegunaan: Refresh idle state killer
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Killer"):WaitForChild("IdleRefresh Event"):FireServer()

-- Remotes.Killers.Killer.PowerDoneDeactivating
-- Kegunaan: Power selesai deactivating
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Killer"):WaitForChild("PowerDoneDeactivating"):FireServer()

-- Remotes.Killers.Killer.ShowPlayers
-- Kegunaan: Tampilkan semua player (reveal survivors)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Killer"):WaitForChild("ShowPlayers"):FireServer()

-- Remotes.Killers.Killer.Stopfrenzyanim
-- Kegunaan: Stop animasi frenzy
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Killer"):WaitForChild("Stopfrenzyanim"):FireServer()

-- Remotes.Killers.Masked.Activatepower
-- Kegunaan: Masked killer activate power
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Masked"):WaitForChild("Activatepower"):FireServer()

-- Remotes.Killers.Masked.Deactivatepower
-- Kegunaan: Masked killer deactivate power
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Masked"):WaitForChild("Deactivatepower"):FireServer()

-- Remotes.Killers.Masked.Maskon
-- Kegunaan: Masked killer pasang mask
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Masked"):WaitForChild("Maskon"):FireServer()

-- Remotes.Killers.Masked.StopDash
-- Kegunaan: Masked killer stop dash attack
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Masked"):WaitForChild("StopDash"):FireServer()

-- Remotes.Killers.Masked.alexattack
-- Kegunaan: Masked killer special attack (Alex attack)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Masked"):WaitForChild("alexattack"):FireServer()

-- Remotes.Killers.Masked.playsound
-- Kegunaan: Masked killer play sound effect
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Masked"):WaitForChild("playsound"):FireServer()

-- Remotes.Killers.Stalker.CancelGrabHitbox
-- Kegunaan: Stalker cancel grab hitbox
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Stalker"):WaitForChild("CancelGrabHitbox"):FireServer()

-- Remotes.Killers.Stalker.ConsumeReady
-- Kegunaan: Stalker consume ready (evolve)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Stalker"):WaitForChild("ConsumeReady"):FireServer()

-- Remotes.Killers.Stalker.Evolve
-- Kegunaan: Stalker evolve (naik level)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Stalker"):WaitForChild("Evolve"):FireServer()

-- Remotes.Killers.Stalker.EvolveStage
-- Kegunaan: Stalker evolve stage (set stage evolution)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Stalker"):WaitForChild("EvolveStage"):FireServer()

-- Remotes.Killers.Stalker.GrabHitResult
-- Kegunaan: Stalker grab hit result
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Stalker"):WaitForChild("GrabHitResult"):FireServer()

-- Remotes.Killers.Stalker.StartGrabHitbox
-- Kegunaan: Stalker mulai grab hitbox
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Stalker"):WaitForChild("StartGrabHitbox"):FireServer()

-- Remotes.Killers.Stalker.StartStalking
-- Kegunaan: Stalker mulai stalking
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Stalker"):WaitForChild("StartStalking"):FireServer()

-- Remotes.Killers.Stalker.StopStalking
-- Kegunaan: Stalker berhenti stalking
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Stalker"):WaitForChild("StopStalking"):FireServer()

-- Remotes.Killers.Stalker.UpdateStalking
-- Kegunaan: Stalker update stalking progress
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Stalker"):WaitForChild("UpdateStalking"):FireServer()

-- Remotes.Killers.Stalker.grab
-- Kegunaan: Stalker grab survivor
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Stalker"):WaitForChild("grab"):FireServer()

-- Remotes.Killers.veil.Damage
-- Kegunaan: Veil killer damage ability
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("veil"):WaitForChild("Damage"):FireServer()

-- Remotes.Killers.veil.Highlightbindable
-- Kegunaan: Veil killer highlight (bindable)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("veil"):WaitForChild("Highlightbindable"):FireServer()

-- Remotes.Killers.veil.Highlightremote
-- Kegunaan: Veil killer highlight (remote)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("veil"):WaitForChild("Highlightremote"):FireServer()

-- Remotes.Killers.veil.Instinct
-- Kegunaan: Veil killer instinct ability
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("veil"):WaitForChild("Instinct"):FireServer()

-- Remotes.Killers.veil.SetAction
-- Kegunaan: Veil killer set action state
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("veil"):WaitForChild("SetAction"):FireServer()

-- Remotes.Killers.veil.SlowAttack
-- Kegunaan: Veil killer slow attack
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("veil"):WaitForChild("SlowAttack"):FireServer()

-- Remotes.Killers.veil.Startmori
-- Kegunaan: Veil killer start mori (kill animation)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("veil"):WaitForChild("Startmori"):FireServer()

-- Remotes.Killers.veil.Stunned
-- Kegunaan: Veil killer stunned (terkena stun dari pallet dsb)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("veil"):WaitForChild("Stunned"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 10: MECHANICS
-- ═══════════════════════════════════════════════════════════

-- Remotes.Mechanics.Chat.PermaBan
-- Kegunaan: Permanen ban player dari chat
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Chat"):WaitForChild("PermaBan"):FireServer()

-- Remotes.Mechanics.Chat.TempBan
-- Kegunaan: Temporary ban player dari chat
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Chat"):WaitForChild("TempBan"):FireServer()

-- Remotes.Mechanics.Chat.Unban
-- Kegunaan: Unban player dari chat
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Chat"):WaitForChild("Unban"):FireServer()

-- Remotes.Mechanics.Chat.ChatTags
-- Kegunaan: Set chat tags (VIP, mod, dll)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Chat"):WaitForChild("ChatTags"):FireServer()

-- Remotes.Mechanics.Chat.ModActivity
-- Kegunaan: Log mod activity
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Chat"):WaitForChild("ModActivity"):FireServer()

-- ⭐ Remotes.Mechanics.Status.Applymori
-- Kegunaan: Apply mori state (kill animation oleh killer)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Status"):WaitForChild("Applymori"):FireServer()

-- ⭐ Remotes.Mechanics.Status.Applysp
-- Kegunaan: Apply SP (Spawn Protection?) ke player
-- Mungkin bisa bikin invincible sementara setelah spawn/revive
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Status"):WaitForChild("Applysp"):FireServer()

-- ⭐ Remotes.Mechanics.Status.ChangeAttribute
-- Kegunaan: ✅ HAPUS STATE INJURED/CROUCHING
-- Saat darah berkurang, game set attribute "Crouchingserver" = true (state sekarat/injured)
-- Dengan kirim ChangeAttribute("Crouchingserver", false), state injured dihapus!
-- Ini yang game kirim saat heal partial damage (bukan knock)
-- Argumen: ("Crouchingserver", false) — nama attribute + nilai baru
-- Bisa juga attribute lain? Cek Explorer > Character > HumanoidRootPart > Attributes
local args = { "Crouchingserver", false }
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Status"):WaitForChild("ChangeAttribute"):FireServer(unpack(args))

-- Remotes.Mechanics.Status.Crouch
-- Kegunaan: Toggle crouch state (berjongkok)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Status"):WaitForChild("Crouch"):FireServer()

-- Remotes.Mechanics.Status.Fall
-- Kegunaan: Fall event (terjatuh dari ketinggian)
-- Argumen: (-100) — damage fall
local args = { -100 }
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Status"):WaitForChild("Fall"):FireServer(unpack(args))

-- Remotes.Mechanics.Status.Firemoricam
-- Kegunaan: Fire mori camera (cutscene saat mori)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Status"):WaitForChild("Firemoricam"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 11: OPTIONS
-- ═══════════════════════════════════════════════════════════

-- Remotes.Options.changeoption
-- Kegunaan: Ubah opsi game (setting player)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Options"):WaitForChild("changeoption"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 12: PALLET
-- ═══════════════════════════════════════════════════════════

-- Remotes.Pallet.Jason.Destroy
-- Kegunaan: Destroy pallet (Jason killer special)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("Jason"):WaitForChild("Destroy"):FireServer()

-- Remotes.Pallet.Jason.Destroy-Global
-- Kegunaan: Destroy pallet global (semua player lihat)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("Jason"):WaitForChild("Destroy-Global"):FireServer()

-- Remotes.Pallet.Jason.Stun
-- Kegunaan: Stun killer dengan pallet (Jason)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("Jason"):WaitForChild("Stun"):FireServer()

-- Remotes.Pallet.Jason.StunDrop
-- Kegunaan: Stun + drop pallet (Jason)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("Jason"):WaitForChild("StunDrop"):FireServer()

-- Remotes.Pallet.Jason.Stunover
-- Kegunaan: Stun selesai (Jason)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("Jason"):WaitForChild("Stunover"):FireServer()

-- Remotes.Pallet.Pallet DropAnim
-- Kegunaan: Animasi jatuhkan pallet
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("Pallet DropAnim"):FireServer()

-- Remotes.Pallet.Pallet DropEvent
-- Kegunaan: Event jatuhkan pallet
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("Pallet DropEvent"):FireServer()

-- Remotes.Pallet.PalletSlideAnim
-- Kegunaan: Animasi slide melewati pallet
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("PalletSlideAnim"):FireServer()

-- Remotes.Pallet.PalletSlideComplete Event
-- Kegunaan: Selesai slide melewati pallet
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("PalletSlideComplete Event"):FireServer()

-- Remotes.Pallet.PalletSlideEvent
-- Kegunaan: Mulai slide melewati pallet
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("PalletSlideEvent"):FireServer()

-- Remotes.Pallet.Slidebindable
-- Kegunaan: Slide bindable event (client-side trigger)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("Slidebindable"):FireServer()

-- Remotes.Pallet.Perks.Escaped
-- Kegunaan: Perk Escaped (berhasil lolos dari chase)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("Perks"):WaitForChild("Escaped"):FireServer()

-- Remotes.Pallet.Perks.Great Collapse
-- Kegunaan: Perk Great Collapse (pallet ability)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pallet"):WaitForChild("Perks"):WaitForChild("Great Collapse"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 13: PROGRESS
-- ═══════════════════════════════════════════════════════════

-- Remotes.Progress.ProgressBindable
-- Kegunaan: Progress bindable event (client-side)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Progress"):WaitForChild("ProgressBindable"):FireServer()

-- Remotes.Progress.ProgressUpdateEvent
-- Kegunaan: Update progress (generator repair, dll)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Progress"):WaitForChild("ProgressUpdateEvent"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 14: SPECTATE
-- ═══════════════════════════════════════════════════════════

-- Remotes.Spectate.Spectateenabler
-- Kegunaan: Enable/disable spectate mode (setelah mati)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Spectate"):WaitForChild("Spectateenabler"):FireServer()

-- ═══════════════════════════════════════════════════════════
-- SECTION 15: WINDOW / VAULT
-- ═══════════════════════════════════════════════════════════

-- Remotes.Window.VaultAnim
-- Kegunaan: Animasi vault (loncat jendela)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Window"):WaitForChild("VaultAnim"):FireServer()

-- Remotes.Window.VaultAnim-jason
-- Kegunaan: Animasi vault khusus Jason killer
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Window"):WaitForChild("VaultAnim-jason"):FireServer()

-- Remotes.Window.VaultCompleteEvent
-- Kegunaan: Selesaikan vault
-- Argumen: (VaultTrigger Part, false)
local args = {
    workspace:WaitForChild("Map"):WaitForChild("Window"):WaitForChild("VaultTrigger"),
    false
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Window"):WaitForChild("VaultCompleteEvent"):FireServer(unpack(args))

-- Remotes.Window.VaultComplete Eventpart1
-- Kegunaan: Bagian pertama vault complete (skip sebagian animasi)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Window"):WaitForChild("VaultComplete Eventpart1"):FireServer()

-- Remotes.Window.VaultEvent
-- Kegunaan: Mulai animasi vault
-- Argumen: (VaultTrigger Part, true)
local args = {
    workspace:WaitForChild("Map"):WaitForChild("Window"):WaitForChild("VaultTrigger"),
    true
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Window"):WaitForChild("VaultEvent"):FireServer(unpack(args))

-- Remotes.Window.VaultEvent-jason
-- Kegunaan: Vault event khusus Jason killer
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Window"):WaitForChild("VaultEvent-jason"):FireServer()

-- Remotes.Window.Vaultbindable
-- Kegunaan: Vault bindable event (client-side)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Window"):WaitForChild("Vaultbindable"):FireServer()

-- Remotes.Window.fastvault
-- Kegunaan: Fast vault — skip animasi vault, langsung selesai
-- Argumen: (Player)
local args = { game:GetService("Players"):WaitForChild("Saycho_o") }
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Window"):WaitForChild("fastvault"):FireServer(unpack(args))

-- ═══════════════════════════════════════════════════════════
-- SECTION 16: ROOT LEVEL REMOTES
-- ═══════════════════════════════════════════════════════════

-- Remotes.GetStarter PackOwned
-- Kegunaan: Cek starter pack yang dimiliki player
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetStarter PackOwned"):FireServer()

-- Remotes.AnimationHandler
-- Kegunaan: Handle animasi character (play/stop animasi)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("AnimationHandler"):FireServer()

-- Remotes.AttackEvent
-- Kegunaan: Event serangan umum (mirror dari Attacks.BasicAttack?)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("AttackEvent"):FireServer()

-- Remotes.Clone
-- Kegunaan: Clone sesuatu (mungkin clone character untuk visual effect)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Clone"):FireServer()

-- Remotes.Darkness
-- Kegunaan: Efek kegelapan (darkness overlay)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Darkness"):FireServer()

-- Remotes.Darkness2
-- Kegunaan: Efek kegelapan fase 2 (lebih gelap?)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Darkness2"):FireServer()

-- Remotes.EmoteHandler
-- Kegunaan: ✅ Kontrol emote animasi (stop emote setelah heal/revive)
-- Argumen: ("StopEmote") — menghentikan animasi emote yang sedang jalan
-- Biasanya dipanggil setelah HealEvent/Reset supaya animasi heal berhenti
local args = { "StopEmote" }
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EmoteHandler"):FireServer(unpack(args))

-- Remotes.FovEvent
-- Kegunaan: Ubah field of view (FOV) kamera
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FovEvent"):FireServer()

-- Remotes.Load
-- Kegunaan: Load something (mungkin load character data)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Load"):FireServer()

-- Remotes.MarkServer Teleport
-- Kegunaan: Mark server untuk teleport (server-side teleport marker)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("MarkServer Teleport"):FireServer()

-- Remotes.Round
-- Kegunaan: Round event (mulai/akhir ronde)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Round"):FireServer()

-- Remotes.SoundPlayer
-- Kegunaan: Mainkan sound effect (musik, SFX)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SoundPlayer"):FireServer()

-- Remotes.StarterPackOwnedChanged
-- Kegunaan: Event saat starter pack berubah
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("StarterPackOwnedChanged"):FireServer()

-- Remotes.Status UpdateEvent
-- Kegunaan: ✅ Update status player (injured, broken, exhausted, dll)
-- Mungkin bisa dipakai untuk update status ke "alive"/"healthy"
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Status UpdateEvent"):FireServer()

-- Remotes.Suspense MusicEvent
-- Kegunaan: Mainkan musik suspense
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Suspense MusicEvent"):FireServer()

-- Remotes.Teleport
-- Kegunaan: Teleport player (masuk/keluar game, atau ke lobby)
-- FireServer() — tanpa argumen, kemungkinan teleport ke lobby/leave match
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Teleport"):FireServer()

-- FireServer(true) — dengan argumen true, kemungkinan masuk ke match/queue
local args = { true }
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Teleport"):FireServer(unpack(args))

-- Remotes.TimeUpdate Event
-- Kegunaan: Update waktu match
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TimeUpdate Event"):FireServer()

-- Remotes.ToggleHairOption
-- Kegunaan: Toggle opsi rambut character
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ToggleHairOption"):FireServer()

-- Remotes.cameraswitch
-- Kegunaan: Switch kamera (first person/third person/cutscene)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("cameraswitch"):FireServer()

-- Remotes.platform
-- Kegunaan: Platform event (mungkin related ke mobile platform support)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("platform"):FireServer()
