-- ============================================================
-- REMOTE VD — Daftar Remote Violence District (Dari RemoteSpy)
-- Semua remote sudah di-unique (tidak ada double)
-- Setiap remote disertai keterangan kegunaan & cara pakai
-- ============================================================

-- ═══════════════════════════════════════════════════════════
-- SECTION 1: TELEPORT
-- ═══════════════════════════════════════════════════════════

-- 1. Remotes.Teleport
-- Kegunaan: Teleport player (masuk/m keluar game, atau ke lobby)
-- FireServer() — tanpa argumen, kemungkinan teleport ke lobby/leave match
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Teleport"):FireServer()

-- FireServer(true) — dengan argumen true, kemungkinan masuk ke match/queue
local args = { true }
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Teleport"):FireServer(unpack(args))

-- ═══════════════════════════════════════════════════════════
-- SECTION 2: WINDOW / VAULT
-- ═══════════════════════════════════════════════════════════

-- 2. Remotes.Window.VaultEvent
-- Kegunaan: Mulai animasi vault (loncat jendela/pagar)
-- Argumen: (VaultTrigger Part, true) — true = mulai vault
local args = {
    workspace:WaitForChild("Map"):WaitForChild("Window"):WaitForChild("VaultTrigger"),
    true
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Window"):WaitForChild("VaultEvent"):FireServer(unpack(args))

-- 3. Remotes.Window.VaultCompleteEvent
-- Kegunaan: Selesaikan vault (kirim bahwa vault sudah selesai)
-- Argumen: (VaultTrigger Part, false) — false = vault selesai
local args = {
    workspace:WaitForChild("Map"):WaitForChild("Window"):WaitForChild("VaultTrigger"),
    false
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Window"):WaitForChild("VaultCompleteEvent"):FireServer(unpack(args))

-- 4. Remotes.Window.VaultCompleteEventpart1
-- Kegunaan: Bagian pertama dari vault complete (skip sebagian animasi)
-- Tanpa argumen
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Window"):WaitForChild("VaultCompleteEventpart1"):FireServer()

-- 5. Remotes.Window.fastvault
-- Kegunaan: Fast vault — skip animasi vault, langsung selesai
-- Argumen: (Player) — player yang melakukan fast vault
local args = {
    game:GetService("Players"):WaitForChild("Saycho_o")
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Window"):WaitForChild("fastvault"):FireServer(unpack(args))

-- ═══════════════════════════════════════════════════════════
-- SECTION 3: MECHANICS
-- ═══════════════════════════════════════════════════════════

-- ⭐ 17. Remotes.Mechanics.ChangeAttribute
-- Kegunaan: ✅ HAPUS STATE INJURED/CROUCHING — INI KUNCI SELF-HEAL!
-- Saat darah berkurang, game set attribute "Crouchingserver" = true (state sekarat/injured)
-- Dengan kirim ChangeAttribute("Crouchingserver", false), state injured dihapus!
-- Ini yang game kirim saat player di-heal orang lain (urutan #1 dari 3 remote)
-- ⚠️ Game VD: HP < 50 = KNOCKED, HP 50-100 = ALIVE
-- Argumen: ("Crouchingserver", false) — nama attribute + nilai baru
-- Bisa juga attribute lain? Cek Explorer > Character > HumanoidRootPart > Attributes
local args = {
    "Crouchingserver",
    false
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("ChangeAttribute"):FireServer(unpack(args))

-- ═══════════════════════════════════════════════════════════
-- SECTION 4: HEALING (PENTING!)
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
-- FULL HEAL SEQUENCE (dari RemoteSpy saat di-heal orang lain):
--   1. ChangeAttribute("Crouchingserver", false) — hapus injured state
--   2. EmoteHandler("StopEmote") — stop animasi sekarat
--   3. Healing.Reset(Player) — reset knock + restore HP
--   Kalau 3 remote ini dikirim bersamaan = player full heal + bangun knock

-- 6. Remotes.Healing.HealEvent
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

-- 7. Remotes.Healing.Reset
-- Kegunaan: ✅ Reset status DIRI SENDIRI — bangun dari knocked/injured
-- Argumen: (Player) — kirim LocalPlayer, bukan Character!
-- Ini SATU-SATUNYA cara self-revive tanpa bantuan player lain
local args = {
    game:GetService("Players"):WaitForChild("Saycho_o")
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("Reset"):FireServer(unpack(args))

-- 8. Remotes.Healing.SkillCheckResultEvent
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

-- ═══════════════════════════════════════════════════════════
-- SECTION 4: GENERATOR
-- ═══════════════════════════════════════════════════════════

-- 9. Remotes.Generator.RepairEvent
-- Kegunaan: Mulai/kirim progress repair generator
-- Argumen: (Part, false) — Part = GeneratorPoint, false = mulai repair
local args = {
    Instance.new("Part", nil),
    false
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("RepairEvent"):FireServer(unpack(args))

-- ═══════════════════════════════════════════════════════════
-- SECTION 5: ITEMS / BANDAGE
-- ═══════════════════════════════════════════════════════════

-- 10. Remotes.Items.Bandage.Fire
-- Kegunaan: Pakai bandage untuk heal diri sendiri (self-heal via item)
-- Argumen: (false, BandageObject) — false = heal mode, BandageObject = item bandage di character
-- ⚠️ Ini mungkin cara self-heal yang valid! Bandage bisa dipakai untuk diri sendiri
local args = {
    false,
    game:GetService("Players").LocalPlayer.Character:WaitForChild("Bandage"):WaitForChild("Right Arm"):WaitForChild("Bandage")
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Items"):WaitForChild("Bandage"):WaitForChild("Fire"):FireServer(unpack(args))

-- ═══════════════════════════════════════════════════════════
-- SECTION 6: CARRY / HOOK
-- ═══════════════════════════════════════════════════════════

-- 11. Remotes.Carry.UnHookEvent
-- Kegunaan: Lepas diri dari hook (kalau di-gantung killer)
-- Argumen: (HookPoint) — posisi hook yang mau dilepas
local args = {
    workspace:WaitForChild("Map"):WaitForChild("Hook"):WaitForChild("HookPoint")
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("UnHookEvent"):FireServer(unpack(args))

-- ═══════════════════════════════════════════════════════════
-- SECTION 7: EMOTE
-- ═══════════════════════════════════════════════════════════

-- 12. Remotes.EmoteHandler
-- Kegunaan: Kontrol emote animasi (stop emote setelah heal/revive)
-- Argumen: ("StopEmote") — menghentikan animasi emote yang sedang jalan
-- Biasanya dipanggil setelah HealEvent/Reset supaya animasi heal berhenti
local args = {
    "StopEmote"
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EmoteHandler"):FireServer(unpack(args))

-- ═══════════════════════════════════════════════════════════
-- SECTION 8: SHOP / KILLER INFO
-- ═══════════════════════════════════════════════════════════

-- 13. Remotes.Shop.GetEquippedPerks
-- Kegunaan: Cek perk apa saja yang sedang di-equip player
-- InvokeServer (bukan FireServer) — mengembalikan data
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("GetEquippedPerks"):InvokeServer()

-- 14. Remotes.Shop.EquipItem
-- Kegunaan: Equip item dari shop (contoh: equip Bandage)
-- Argumen: ("NamaItem") — nama item yang mau di-equip
local args = {
    "Bandage"
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("EquipItem"):FireServer(unpack(args))

-- 15. Remotes.Shop.CheckKillerOwnership
-- Kegunaan: Cek apakah player punya killer tertentu
-- Argumen: ("NamaKiller") — nama killer yang mau dicek (misal "Hidden", "Stalker")
-- InvokeServer — mengembalikan true/false
local args = {
    "Hidden"
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("CheckKillerOwnership"):InvokeServer(unpack(args))

-- 16. Remotes.Shop.GetSelectedKiller
-- Kegunaan: Cek killer apa yang sedang dipilih/aktif player
-- InvokeServer — mengembalikan nama killer
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("GetSelectedKiller"):InvokeServer()
