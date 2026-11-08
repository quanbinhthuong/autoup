-- ═══════════════════════════════════════════════════════════════
--  CHILLI HUB · PREMIUM EDITION
--  Venyx core · VI translation · Premium UI · No file save
-- ═══════════════════════════════════════════════════════════════

local VENYX_URL = "https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub"

local BRAND = "Chilli Hub"
local SUFFIX = "PRO"
local FULL_BRAND = BRAND .. " " .. SUFFIX
local NEW_TITLE = "CHILLI HUB · PRO"
local LOGO_ID = "rbxassetid://92622270383869"

local COLORS = {
    BgDark = Color3.fromRGB(6, 6, 14),
    BgMid = Color3.fromRGB(14, 12, 28),
    BgPanel = Color3.fromRGB(18, 16, 36),
    BgCard = Color3.fromRGB(24, 22, 44),
    Text = Color3.fromRGB(240, 240, 255),
    TextDim = Color3.fromRGB(150, 150, 180),
    Accent = Color3.fromRGB(200, 60, 90),
    Accent2 = Color3.fromRGB(255, 140, 60),
    Gold = Color3.fromRGB(255, 200, 80),
    Border = Color3.fromRGB(50, 44, 80),
    BorderHi = Color3.fromRGB(120, 90, 180)
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local env = (getgenv and getgenv()) or _G
env.__ChilliProState = env.__ChilliProState or {
    SessionId = 0, Language = "VI", ActiveGradients = {},
    TrackedTexts = {}, NoticeShown = false, StyledElements = {}
}
local State = env.__ChilliProState
State.SessionId = (State.SessionId or 0) + 1
local SID = State.SessionId
local function isAlive() return State.SessionId == SID end

local function mk(cls, props, parent)
    local i = Instance.new(cls)
    for k, v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

local function getScanRoots()
    local r = {}
    if gethui then pcall(function() local h = gethui(); if h then table.insert(r, h) end end) end
    table.insert(r, CoreGui)
    local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then table.insert(r, pg) end
    return r
end

local function safeHttpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    if ok and type(res) == "string" and #res > 10 then return res end
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then
        local rOk, rRes = pcall(req, { Url = url, Method = "GET" })
        if rOk and rRes and type(rRes.Body) == "string" and #rRes.Body > 10 then return rRes.Body end
    end
    return nil
end

local IGNORED_GUIS = {
    RobloxGui=true, TopBarApp=true, TouchGui=true, Chat=true, BubbleChat=true,
    Freecam=true, BackpackGui=true, PlayerList=true, PurchasePrompt=true,
    ChilliPro_NoticeGui=true
}

local RAINBOW = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 80, 120)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 160, 60)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 220, 80)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(120, 200, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 80, 120))
})

local GOLD_GRAD = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 220, 120)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 180, 60)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 220, 120))
})

-- ═══════════════════════════════════════════════════════════════
-- LAUNCH VENYX
-- ═══════════════════════════════════════════════════════════════
local function isVenyxUiPresent()
    for _, root in ipairs(getScanRoots()) do
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local t = d.Text or ""
                if t == "VENYX" or t == "Venyx" or t == NEW_TITLE then return true end
            end
        end
    end
    return false
end

local function launchVenyx()
    if isVenyxUiPresent() then return end
    if env.__ChilliLaunching and (os.clock() - (env.__ChilliLaunchClock or 0) < 8) then return end
    env.__ChilliLaunching = true
    env.__ChilliLaunchClock = os.clock()
    task.spawn(function()
        if not game:IsLoaded() then game.Loaded:Wait() end
        local code = safeHttpGet(VENYX_URL)
        if code then
            local fn = loadstring(code)
            if type(fn) == "function" then pcall(fn) end
        end
        env.__ChilliLaunching = false
    end)
end

launchVenyx()

-- ═══════════════════════════════════════════════════════════════
-- TRANSLATION
-- ═══════════════════════════════════════════════════════════════
local FastCache = {}
local function hasVi(s)
    return type(s) == "string" and s ~= "" and s:find("[\194-\244][\128-\191]") ~= nil
end

local BRAND_MAP = {
    ["Venyx"] = FULL_BRAND,
    ["VENYX"] = NEW_TITLE,
    ["Venyx Hub"] = BRAND .. " Hub " .. SUFFIX,
    ["Venyx Panel"] = BRAND .. " Panel",
    ["Venyx SAE"] = BRAND .. " SAE",
    ["Welcome to Venyx"] = "Chào mừng tới " .. FULL_BRAND,
}

local EXACT_VI = {
    ["Idle"]="Đang rảnh", ["Waiting"]="Đang chờ", ["Nothing"]="Không có gì", ["None"]="Không có",
    ["Off"]="Tắt", ["OFF"]="TẮT", ["On"]="Bật", ["ON"]="BẬT",
    ["No egg matches your targets"]="Không có trứng nào khớp mục tiêu",
    ["No eggs match filter"]="Không có trứng khớp bộ lọc",
    ["No target egg found"]="Không tìm thấy trứng mục tiêu",
    ["Bag is full"]="Túi đã đầy", ["Egg bag is full"]="Túi trứng đã đầy",
    ["Pet bag is full"]="Túi pet đã đầy", ["Pen is full"]="Chuồng ấp đã đầy",
    ["Field is closed"]="Sân trứng đang đóng",
    ["Waiting for field to open"]="Đang chờ sân trứng mở",
    ["Waiting for eggs to spawn"]="Đang chờ trứng xuất hiện",
    ["Waiting in safe zone"]="Đợi ở vùng an toàn",
    ["Returning to safe zone"]="Đang về vùng an toàn",
    ["Delivering egg"]="Đang giao trứng về chuồng",
    ["Dropping egg"]="Đang thả trứng",
    ["Selling eggs"]="Đang bán trứng", ["Selling pets"]="Đang bán pet",
    ["Hatching eggs"]="Đang ấp trứng", ["Placing eggs"]="Đang đặt trứng",
    ["Mutating eggs"]="Đang đột biến trứng", ["Fusing pets"]="Đang dung hợp pet",
    ["Hopping server"]="Đang đổi máy chủ", ["Rejoining"]="Đang vào lại phòng",
    ["Avoiding guard"]="Đang né vệ sĩ", ["Using treadmill"]="Đang chạy máy tập",
    ["Upgrading treadmill"]="Đang nâng cấp máy tập", ["Upgrading base"]="Đang nâng cấp căn cứ",
    ["Claiming rewards"]="Đang nhận thưởng", ["Claiming offline cash"]="Đang nhận tiền ngoại tuyến",
    ["Joining race"]="Đang vào đường đua", ["Racing"]="Đang đua xe",
    ["Home"]="Bảng Điều Khiển", ["Dashboard"]="Bảng Điều Khiển",
    ["Welcome back"]="Chào mừng trở lại",
    ["Updates, keys, support"]="Cập nhật, nhận key, hỗ trợ",
    ["Copy Invite"]="Chép Link Mời", ["MONEY /S"]="TIỀN /GIÂY",
    ["OPEN"]="MỞ", ["Open"]="Mở", ["Close"]="Đóng",
    ["Rejoin"]="Vào lại", ["Server hop"]="Đổi server", ["Copy Job ID"]="Chép Job ID",
    ["Unload hub"]="Tắt Hub", ["Save config"]="Lưu cấu hình", ["Hide UI"]="Ẩn Menu",
    ["SESSION"]="PHIÊN CHƠI", ["STOLEN"]="ĐÃ CƯỚP", ["LAST EGG"]="TRỨNG CUỐI",
    ["PLACED"]="ĐÃ ĐẶT", ["HATCHED"]="ĐÃ ẤP", ["SESSION TIME"]="THỜI GIAN",
    ["BEST STEAL"]="CƯỚP TỐT NHẤT", ["EGG BAG"]="TÚI TRỨNG", ["PET BAG"]="TÚI PET",
    ["WHAT'S NEW"]="CÓ GÌ MỚI", ["NEW"]="MỚI",
    ["Event"]="Sự Kiện", ["Search"]="Tìm kiếm", ["Filter"]="Lọc tìm",
    ["Steal"]="Cướp Trứng", ["Auto Steal"]="Tự Động Cướp", ["AUTO STEAL"]="TỰ ĐỘNG CƯỚP",
    ["Auto steal"]="Tự động cướp", ["Egg Predictor"]="Dự Đoán Trứng",
    ["Go to egg"]="Di chuyển tới trứng", ["Teleport to egg"]="Dịch chuyển tới trứng",
    ["Teleport zones"]="Khu vực dịch chuyển", ["Tween"]="Bay (Tween)", ["Walk"]="Đi bộ",
    ["Delivery method"]="Cách mang về", ["Fast tween speed"]="Tốc độ bay nhanh",
    ["Tween speed"]="Tốc độ bay",
    ["Steal missing index eggs"]="Cướp trứng thiếu trong Chỉ mục",
    ["Steal from other players"]="Cướp từ người chơi khác",
    ["Anti guard"]="Chống vệ sĩ", ["Drop eggs at safe zone"]="Thả trứng ở vùng an toàn",
    ["FILTER"]="BỘ LỌC", ["Zones"]="Khu vực", ["Steal first"]="Ưu tiên cướp",
    ["Best value"]="Giá trị cao nhất", ["Lowest value"]="Giá trị thấp nhất",
    ["Best rarity"]="Độ hiếm cao nhất", ["Best mutation"]="Đột biến tốt nhất",
    ["Biggest"]="Kích thước to nhất", ["Closest"]="Khoảng cách gần nhất",
    ["Mutations"]="Đột biến", ["Rarities"]="Độ hiếm",
    ["Only these eggs"]="Chỉ những trứng này",
    ["Min value /s"]="Giá trị tối thiểu /s", ["Max value /s"]="Giá trị tối đa /s",
    ["Sell cheapest egg when bag is full"]="Bán trứng rẻ nhất khi đầy túi",
    ["Keep lab eggs"]="Giữ lại trứng Lab",
    ["AUTO HOP SERVER"]="TỰ ĐỔI MÁY CHỦ", ["Auto hop server"]="Tự đổi máy chủ",
    ["Hop delay"]="Độ trễ đổi server",
    ["EGG SHOWCASE"]="TRƯNG BÀY TRỨNG", ["Sort eggs"]="Sắp xếp trứng",
    ["Preview card"]="Thẻ xem trước", ["Pick one"]="Chọn một mục",
    ["Pick any"]="Chọn bất kỳ", ["Value"]="Giá trị", ["Rarity"]="Độ hiếm",
    ["Time left"]="Thời gian còn lại", ["Default"]="Mặc định",
    ["Clear"]="Xóa chọn", ["Select all"]="Chọn tất cả",
    ["SIZE"]="KÍCH CỠ", ["WEIGHT"]="CÂN NẶNG", ["READY"]="SẴN SÀNG",
    ["IN BAG"]="TRONG TÚI", ["GROWING"]="ĐANG LỚN",
    ["Hatch now"]="Ấp ngay", ["Hold egg"]="Cầm trứng",
    ["Fly to egg"]="Bay tới trứng", ["Steal egg"]="Cướp trứng",
    ["Enchanted Forest"]="Rừng Phù Phép", ["Light Dark"]="Sáng Tối",
    ["Titan Temple"]="Đền Titan", ["Cherry Blossom"]="Hoa Anh Đào",
    ["Prehistoric"]="Tiền Sử", ["Abyss Ocean"]="Đáy Đại Dương",
    ["Volcano"]="Núi Lửa", ["Snow"]="Tuyết", ["Jungle"]="Rừng Rậm",
    ["Desert"]="Sa Mạc", ["Lake"]="Hồ Nước", ["Forest"]="Khu Rừng",
    ["Silver"]="Bạc", ["Rainbow"]="Cầu Vồng", ["Golden"]="Vàng",
    ["Fractured"]="Rạn Nứt", ["Scrambled"]="Hỗn Loạn", ["Enchanted"]="Phù Phép",
    ["Nitro"]="Nitro",
    ["Farm"]="Cày Cuốc", ["Pen"]="Chuồng Ấp", ["PEN"]="CHUỒNG ẤP",
    ["Treadmill"]="Máy Tập", ["TREADMILL"]="MÁY TẬP CHẠY",
    ["Mutate"]="Đột Biến", ["Sell"]="Bán", ["SELL"]="BÁN TỰ ĐỘNG",
    ["Fuse"]="Dung Hợp", ["FUSE"]="DUNG HỢP",
    ["Priority"]="Ưu Tiên", ["PRIORITY"]="THỨ TỰ ƯU TIÊN",
    ["AUTO PLACE"]="TỰ ĐỘNG ĐẶT TRỨNG", ["Auto place"]="Tự động đặt trứng",
    ["Place when"]="Đặt khi", ["Always"]="Luôn luôn", ["Place first"]="Ưu tiên đặt",
    ["AUTO HATCH"]="TỰ ĐỘNG ẤP TRỨNG", ["Auto hatch"]="Tự động ấp trứng",
    ["Equip best pets"]="Trang bị pet mạnh nhất",
    ["Auto treadmill"]="Tự chạy máy tập",
    ["Auto upgrade treadmill"]="Tự nâng cấp máy tập",
    ["PROGRESS"]="TIẾN TRÌNH", ["Auto upgrade base"]="Tự nâng cấp căn cứ",
    ["Auto buy trails"]="Tự mua vệt sáng",
    ["Auto claim offline cash"]="Tự nhận tiền ngoại tuyến",
    ["Auto claim index rewards"]="Tự nhận thưởng Chỉ mục",
    ["AUTO MUTATE"]="TỰ ĐỘNG ĐỘT BIẾN", ["Auto mutate"]="Tự động đột biến",
    ["MUTATE FILTER"]="BỘ LỌC ĐỘT BIẾN", ["Use items"]="Dùng vật phẩm",
    ["Mutate first"]="Ưu tiên đột biến",
    ["PETS"]="THÚ CƯNG (PETS)", ["EGGS"]="TRỨNG (EGGS)",
    ["Auto sell pets"]="Tự động bán pet", ["Auto sell eggs"]="Tự động bán trứng",
    ["Sell rarities"]="Độ hiếm bán", ["Never sell"]="Không bao giờ bán",
    ["Only mutations"]="Chỉ bán đột biến", ["Only below /s"]="Chỉ dưới mức /s",
    ["Keep mutated"]="Giữ lại đồ đột biến",
    ["LAB EGGS"]="TRỨNG PHÒNG LAB", ["FAVORITE"]="YÊU THÍCH (KHÓA)",
    ["Auto favorite"]="Tự động khóa bảo vệ",
    ["Auto sell lab eggs"]="Tự động bán trứng Lab",
    ["Match"]="Điều kiện khớp", ["All picked rules"]="Khớp tất cả quy tắc",
    ["Any picked rule"]="Khớp bất kỳ quy tắc",
    ["Favorite equipped"]="Khóa pet đang trang bị",
    ["FUSE MACHINE"]="MÁY DUNG HỢP", ["Auto fuse"]="Tự động dung hợp",
    ["Fuse first"]="Ưu tiên dung hợp", ["Lowest rarity"]="Độ hiếm thấp nhất",
    ["Highest rarity"]="Độ hiếm cao nhất", ["Use pets"]="Sử dụng pet",
    ["Lowest value first"]="Giá trị thấp nhất trước",
    ["Highest value first"]="Giá trị cao nhất trước",
    ["Skip mutated"]="Bỏ qua pet đột biến",
    ["Eject odd pets"]="Đẩy pet lẻ ra ngoài",
    ["FUSE FILTER"]="BỘ LỌC DUNG HỢP", ["Only these pets"]="Chỉ những pet này",
    ["Never fuse"]="Không bao giờ dung hợp",
    ["TASK ORDER"]="THỨ TỰ TÁC VỤ", ["DOING"]="ĐANG LÀM", ["WAITING"]="ĐANG CHỜ",
    ["Player"]="Người Chơi", ["ESP"]="Định Vị (ESP)", ["Move"]="Di Chuyển",
    ["Combat"]="Chiến Đấu",
    ["FIELD EGGS"]="TRỨNG NGOÀI SÂN", ["Egg ESP"]="ESP Trứng",
    ["Show"]="Hiển thị", ["Name"]="Tên", ["Fixed size"]="Cố định kích cỡ",
    ["OTHERS"]="MỤC KHÁC", ["Guard ESP"]="ESP Vệ sĩ",
    ["Player ESP"]="ESP Người chơi", ["ESP size"]="Kích cỡ ESP",
    ["MOVEMENT"]="TỐC ĐỘ & DI CHUYỂN", ["Speed boost"]="Tăng tốc chạy",
    ["Boost speed"]="Tốc độ tăng thêm", ["Infinite jump"]="Nhảy vô hạn",
    ["God mode"]="Bất tử (God mode)",
    ["PROTECTION"]="BẢO VỆ NHÂN VẬT", ["Anti ragdoll"]="Chống ngã",
    ["Ignore traps"]="Bỏ qua bẫy", ["Instant prompts"]="Tương tác tức thì",
    ["Anti AFK"]="Chống treo máy", ["Invisible"]="Tàng hình",
    ["AUTO HIT"]="TỰ ĐỘNG ĐÁNH", ["Auto hit"]="Tự động đánh",
    ["Hit who"]="Mục tiêu đánh", ["Nearest player"]="Người chơi gần nhất",
    ["Chosen player"]="Người chơi chỉ định",
    ["Chase speed"]="Tốc độ đuổi theo",
    ["HIT AURA"]="VÒNG ĐÁNH TỰ ĐỘNG", ["Hit aura"]="Vòng đánh tự động",
    ["Skip friends"]="Bỏ qua bạn bè",
    ["WEAPONS"]="VŨ KHÍ", ["Use weapons"]="Sử dụng vũ khí",
    ["Hold each"]="Thời gian cầm mỗi món",
    ["System"]="Hệ Thống", ["Server"]="Máy Chủ",
    ["Webhook"]="Webhook", ["Optimizer"]="Tối Ưu Hóa",
    ["Interface"]="Giao Diện", ["Config"]="Cấu Hình",
    ["ACTIVE"]="ĐANG DÙNG", ["SAVED CONFIGS"]="ĐÃ LƯU",
    ["Save"]="Lưu", ["PROFILES"]="HỒ SƠ CẤU HÌNH",
    ["Create"]="Tạo mới", ["Delete"]="Xóa",
    ["Export config"]="Xuất mã cấu hình",
    ["Import text"]="Dán mã cấu hình",
    ["Import config"]="Nhập cấu hình", ["Import"]="Nhập",
    ["Config imported"]="Đã nhập cấu hình", ["Config loaded"]="Đã nạp cấu hình",
    ["Later"]="Để sau", ["Apply now"]="Áp dụng ngay",
    ["Hop to"]="Chuyển tới server",
    ["Least players"]="Ít người chơi nhất",
    ["Most players"]="Đông người chơi nhất",
    ["Random"]="Ngẫu nhiên",
    ["Hop server"]="Đổi máy chủ", ["Hop"]="Đổi ngay",
    ["Rejoin this server"]="Vào lại máy chủ này",
    ["Copy"]="Sao chép",
    ["JOIN AND STAY"]="VÀO PHÒNG & DUY TRÌ",
    ["Job ID"]="Mã phòng (Job ID)",
    ["Join"]="Vào ngay",
    ["Rejoin on kick"]="Tự vào lại khi bị văng",
    ["Auto load script"]="Tự chạy lại script khi chuyển server",
    ["DISCORD WEBHOOK"]="WEBHOOK DISCORD",
    ["Webhook URL"]="Đường dẫn Webhook",
    ["Ping everyone"]="Tag @everyone",
    ["WHAT TO POST"]="NỘI DUNG GỬI BÁO CÁO",
    ["Post stolen eggs"]="Báo cáo trứng cướp được",
    ["Post fused eggs"]="Báo cáo trứng dung hợp",
    ["POSTED"]="ĐÃ GỬI",
    ["Send a test post"]="Gửi tin nhắn thử nghiệm", ["Test"]="Thử nghiệm",
    ["Post when bag is full"]="Gửi thông báo khi đầy túi",
    ["GRAPHICS"]="ĐỒ HỌA", ["Low graphics"]="Đồ họa thấp (Tăng FPS)",
    ["Disable 3D Render"]="Tắt kết xuất 3D",
    ["Background color"]="Màu nền màn hình",
    ["Black"]="Màu Đen", ["White"]="Màu Trắng",
    ["Hide game UI"]="Ẩn giao diện gốc của Game",
    ["FRAME RATE"]="TỐC ĐỘ KHUNG HÌNH (FPS)",
    ["FPS cap"]="Giới hạn FPS",
    ["Show FPS and ping"]="Hiện chỉ số FPS và Ping",
    ["BASES"]="CĂN CỨ (BASES)",
    ["Hide other players' pets and eggs"]="Ẩn pet và trứng của người chơi khác",
    ["Hide my pets and eggs"]="Ẩn pet và trứng của bản thân",
    ["Theme"]="Chủ đề màu", ["Toggle key"]="Phím đóng/mở Menu",
    ["Quick bar"]="Thanh phím tắt nhanh",
    ["QUICK BAR"]="THANH PHÍM TẮT NHANH",
    ["Auto save"]="Tự động lưu cấu hình",
    ["Auto load"]="Tự động nạp cấu hình",
    ["Load config"]="Nạp cấu hình",
    ["Reset config"]="Đặt lại mặc định",
    ["Delete config"]="Xóa cấu hình",
    ["Common"]="Phổ Thông", ["Uncommon"]="Thường", ["Rare"]="Hiếm",
    ["Epic"]="Sử Thi", ["Legendary"]="Huyền Thoại", ["Mythic"]="Thần Thoại",
    ["Cosmic"]="Vũ Trụ", ["Secret"]="Bí Ẩn", ["Divine"]="Thánh Thần",
    ["Eternal"]="Vĩnh Cửu",
    ["COMMON"]="PHỔ THÔNG", ["UNCOMMON"]="THƯỜNG", ["RARE"]="HIẾM",
    ["EPIC"]="SỬ THI", ["LEGENDARY"]="HUYỀN THOẠI",
    ["MYTHIC"]="THẦN THOẠI", ["COSMIC"]="VŨ TRỤ",
    ["SECRET"]="BÍ ẨN", ["DIVINE"]="THÁNH THẦN", ["ETERNAL"]="VĨNH CỬU"
}

local LOWER_VI = {}
for k, v in pairs(EXACT_VI) do LOWER_VI[k:lower()] = v end

local PHRASES_VI = {
    {"cursed island wars","Đại Chiến Đảo Nguyền Rủa"},
    {"island wars","Đảo Nguyền Rủa"},
    {"phantom express","Tàu Ma Phantom Express"},
    {"pumpkin moon","Trăng Bí Ngô"},
    {"halloween dimension","Không gian Halloween"},
    {"ghost dog","Chó Ma"},
    {"admin treadmill","máy tập Admin"},
    {"instant steal","cướp tức thì"},
    {"capture the egg","Cướp trứng sự kiện"},
    {"waiting for field to open","Đang chờ sân trứng mở"},
    {"waiting for eggs to spawn","Đang chờ trứng xuất hiện"},
    {"waiting in safe zone","Đợi ở vùng an toàn"},
    {"returning to safe zone","Đang về vùng an toàn"},
    {"egg bag is full","Túi trứng đã đầy"},
    {"pet bag is full","Túi pet đã đầy"},
    {"bag is full","Túi đã đầy"},
    {"pen is full","Chuồng đã đầy"},
    {"field is closed","Sân trứng đang đóng"},
    {"safe zone","vùng an toàn"},
    {"other players","người chơi khác"},
    {"missing index","thiếu trong Chỉ mục"},
    {"shooting star","sao băng"},
    {"butterfly bloom","mùa bướm nở"},
    {"racing event","sự kiện đua xe"},
    {"offline cash","tiền ngoại tuyến"},
    {"index rewards","thưởng Chỉ mục"},
    {"lab eggs","trứng Lab"},
    {"event egg","trứng sự kiện"},
    {"minigame eggs","trứng Minigame"},
    {"minigame egg","trứng Minigame"},
    {"wisp eggs","trứng Wisp"},
    {"to safe zone","về vùng an toàn"},
    {"to safety","đến nơi an toàn"},
    {"to base","về căn cứ"},
    {"to pen","vào chuồng"}
}

local WORDS_VI = {
    idle="Đang rảnh", carrying="Đang mang", delivering="Đang giao",
    stealing="Đang cướp", grabbing="Đang nhặt", picking="Đang nhặt",
    collecting="Đang thu thập", holding="Đang giữ", capturing="Đang bắt giữ",
    dropping="Đang thả", tweening="Đang bay", teleporting="Đang dịch chuyển",
    going="Đang đi", moving="Đang di chuyển", walking="Đang đi bộ",
    running="Đang chạy", flying="Đang bay", returning="Đang quay về",
    placing="Đang đặt", hatching="Đang ấp", mutating="Đang đột biến",
    selling="Đang bán", fusing="Đang dung hợp", upgrading="Đang nâng cấp",
    buying="Đang mua", claiming="Đang nhận", equipping="Đang trang bị",
    catching="Đang nhặt", chasing="Đang đuổi theo", attacking="Đang tấn công",
    hitting="Đang đánh", killing="Đang tiêu diệt", trading="Đang đổi",
    crafting="Đang chế tạo", avoiding="Đang né", waiting="Đang chờ",
    searching="Đang tìm", scanning="Đang quét", farming="Đang cày",
    using="Đang dùng", joining="Đang vào", hopping="Đang đổi",
    rejoining="Đang vào lại", finding="Đang tìm", racing="Đang đua",
    ready="Sẵn sàng", nothing="Không có gì", none="Không có", no="Không có",
    pumpkin="bí ngô", pumpkins="bí ngô", altar="bệ thờ",
    monster="quái vật", monsters="quái vật", ghost="ma", ghosts="ma",
    soul="linh hồn", souls="linh hồn", train="chuyến tàu", boss="Boss",
    cursed="nguyền rủa", island="đảo", wars="đại chiến",
    enemies="kẻ địch", walls="tường chắn", crystal="pha lê",
    candy="kẹo", corn="ngô", fishing="câu cá", fish="cá", quest="nhiệm vụ",
    dimension="không gian", delivery="mang về", calculate="tính thử",
    mutation="đột biến", mutations="đột biến",
    weapon="vũ khí", weapons="vũ khí",
    removed="đã gỡ bỏ", added="đã thêm", fixed="đã sửa",
    egg="trứng", eggs="trứng", pet="pet", pets="pet",
    matches="khớp", match="khớp", matching="khớp", your="của bạn",
    target="mục tiêu", targets="mục tiêu", filter="bộ lọc",
    home="về nhà", base="căn cứ", pen="chuồng", pens="chuồng",
    field="sân trứng", zone="khu vực", zones="khu vực",
    bag="túi", full="đầy", empty="trống", closed="đóng", open="mở",
    guard="vệ sĩ", guards="vệ sĩ", player="người chơi", players="người chơi",
    server="máy chủ", treadmill="máy tập", race="đua xe",
    star="sao băng", butterfly="bướm", portal="cổng",
    rewards="thưởng", reward="thưởng", cash="tiền", found="tìm thấy",
    speed="tốc độ", instant="tức thì", steal="cướp", auto="tự động",
    to="tới", from="từ", ["in"]="trong", at="tại", ["for"]="cho",
    with="với", ["and"]="và", ["or"]="hoặc"
}

local GRAMMAR_VI = {
    { pat="^[Aa]uto play (.+)$", rep="Tự động chơi %1" },
    { pat="^[Aa]uto farm (.+)$", rep="Tự động cày %1" },
    { pat="^[Aa]uto kill (.+)$", rep="Tự động tiêu diệt %1" },
    { pat="^[Aa]uto catch (.+)$", rep="Tự động bắt %1" },
    { pat="^[Aa]uto collect (.+)$", rep="Tự động thu thập %1" },
    { pat="^[Aa]uto buy (.+)$", rep="Tự động mua %1" },
    { pat="^[Aa]uto sell (.+)$", rep="Tự động bán %1" },
    { pat="^[Aa]uto claim (.+)$", rep="Tự động nhận %1" },
    { pat="^[Aa]uto upgrade (.+)$", rep="Tự động nâng cấp %1" },
    { pat="^[Aa]uto craft (.+)$", rep="Tự động chế tạo %1" },
    { pat="^[Aa]uto trade (.+)$", rep="Tự động trao đổi %1" },
    { pat="^[Aa]uto equip (.+)$", rep="Tự động trang bị %1" },
    { pat="^[Aa]uto steal (.+)$", rep="Tự động cướp %1" },
    { pat="^[Ii]nstant steal (.+)$", rep="Cướp tức thì %1" },
    { pat="^[Aa]uto (.+) quest$", rep="Tự làm nhiệm vụ %1" },
    { pat="^[Aa]uto (.+)$", rep="Tự động %1" },
    { pat="^[Cc]alculate (.+)$", rep="Tính thử %1" },
    { pat="^(.+) speed$", rep="Tốc độ %1" },
    { pat="^(.+) target$", rep="Mục tiêu %1" },
    { pat="^(.+) order$", rep="Thứ tự %1" },
    { pat="^(.+) priority$", rep="Ưu tiên %1" },
    { pat="^(.+) mode$", rep="Chế độ %1" },
    { pat="^(.+) filter$", rep="Bộ lọc %1" },
    { pat="^[Nn]o eggs? match%w* (.+)$", rep="Không có trứng nào khớp %1" },
    { pat="^[Cc]arrying (.+) to safe zone(.*)$", rep="Đang mang %1 về vùng an toàn%2" },
    { pat="^[Cc]arrying (.+) to base(.*)$", rep="Đang mang %1 về căn cứ%2" },
    { pat="^[Cc]arrying (.+) to pen(.*)$", rep="Đang mang %1 về chuồng%2" },
    { pat="^[Cc]arrying (.+) home(.*)$", rep="Đang mang %1 về nhà%2" },
    { pat="^[Cc]arrying (.+)$", rep="Đang mang %1" },
    { pat="^[Dd]elivering (.+) to (.+)$", rep="Đang giao %1 tới %2" },
    { pat="^[Dd]elivering (.+)$", rep="Đang giao %1" },
    { pat="^[Ss]tealing (.+) from (.+)$", rep="Đang cướp %1 từ %2" },
    { pat="^[Ss]tealing (.+)$", rep="Đang cướp %1" },
    { pat="^[Tt]weening to (.+)$", rep="Đang bay tới %1" },
    { pat="^[Tt]eleporting to (.+)$", rep="Đang dịch chuyển tới %1" },
    { pat="^[Gg]oing to (.+)$", rep="Đang đi tới %1" },
    { pat="^[Rr]eturning to (.+)$", rep="Đang quay về %1" },
    { pat="^[Ww]aiting for (.+)$", rep="Đang chờ %1" }
}

local DYN_VI = {
    { pat="^QUICK BAR (%d+)$", rep="THANH NHANH %1" },
    { pat="^ALL (%d+)$", rep="TẤT CẢ %1" },
    { pat="^READY (%d+)$", rep="SẴN SÀNG %1" },
    { pat="^GROWING (%d+)$", rep="ĐANG LỚN %1" },
    { pat="^IN BAG (%d+)$", rep="TRONG TÚI %1" },
    { pat="(%d+) egg%(s%) can be mutated", rep="%1 trứng có thể đột biến" },
    { pat="(%d+) pet%(s%) match", rep="%1 pet khớp bộ lọc" },
    { pat="(%d+) egg%(s%) match", rep="%1 trứng khớp bộ lọc" }
}

local function stripArt(s)
    return ((" " .. s .. " "):gsub("%s+[Aa]%s+", " "):gsub("%s+[Aa]n%s+", " ")
        :gsub("%s+[Tt]he%s+", " "):match("^%s*(.-)%s*$") or s)
end

local function applyPhrases(s)
    local out = s
    for i = 1, #PHRASES_VI do
        local p = PHRASES_VI[i]
        local a, b = out:lower():find(p[1], 1, true)
        if a then out = out:sub(1, a - 1) .. p[2] .. out:sub(b + 1) end
    end
    return out
end

local function applyWords(s)
    return (stripArt(s):gsub("([%a']+)", function(w)
        local l = w:lower()
        return WORDS_VI[l] or LOWER_VI[l] or w
    end))
end

local function translateStatus(en)
    if not en or en == "" then return State.Language == "EN" and "Idle" or "Đang rảnh" end
    local t = (en:match("^%s*(.-)%s*$") or en):gsub("%.+$", "")
    if State.Language == "EN" then return t == "Đang rảnh" and "Idle" or t end
    if t:lower() == "idle" or t == "Đang rảnh" then return "Đang rảnh" end
    local ck = "ST|" .. t
    if FastCache[ck] then return FastCache[ck] end
    if EXACT_VI[t] or LOWER_VI[t:lower()] then
        local r = EXACT_VI[t] or LOWER_VI[t:lower()]
        FastCache[ck] = r; return r
    end
    local out = stripArt(t)
    for i = 1, #GRAMMAR_VI do
        if out:find(GRAMMAR_VI[i].pat) then
            out = out:gsub(GRAMMAR_VI[i].pat, GRAMMAR_VI[i].rep)
            break
        end
    end
    out = applyWords(applyPhrases(out)):gsub("%s+", " "):match("^%s*(.-)%s*$") or out
    FastCache[ck] = out; return out
end

local function translateText(raw)
    if not raw or raw == "" then return raw end
    local ck = State.Language .. "|" .. raw
    if FastCache[ck] then return FastCache[ck] end
    if BRAND_MAP[raw] then FastCache[ck] = BRAND_MAP[raw]; return BRAND_MAP[raw] end
    if raw == "VENYX" then FastCache[ck] = NEW_TITLE; return NEW_TITLE end
    if State.Language == "EN" then FastCache[ck] = raw; return raw end
    local norm = (raw:match("^%s*(.-)%s*$") or raw):gsub("%s+", " ")
    if norm:match("^[%$%+%-%d%.%,%/%%sxhm]+$") then FastCache[ck] = raw; return raw end
    if EXACT_VI[norm] or LOWER_VI[norm:lower()] then
        local r = EXACT_VI[norm] or LOWER_VI[norm:lower()]
        FastCache[ck] = r; return r
    end
    local pfx, wp = norm:match("^([^%w%s]+%s*)(.+)$")
    if pfx and wp and (EXACT_VI[wp] or LOWER_VI[wp:lower()]) then
        FastCache[ck] = pfx .. (EXACT_VI[wp] or LOWER_VI[wp:lower()])
        return FastCache[ck]
    end
    for i = 1, #DYN_VI do
        if norm:find(DYN_VI[i].pat) then
            FastCache[ck] = norm:gsub(DYN_VI[i].pat, DYN_VI[i].rep)
            return FastCache[ck]
        end
    end
    local res, hit = norm, false
    local caps = (norm:upper() == norm and norm:find("%a") ~= nil)
    for i = 1, #GRAMMAR_VI do
        if res:find(GRAMMAR_VI[i].pat) then
            res = res:gsub(GRAMMAR_VI[i].pat, GRAMMAR_VI[i].rep)
            hit = true; break
        end
    end
    local phr = applyPhrases(res)
    if hit or phr ~= res or res:find("%s") then
        local fin = applyWords(phr):gsub("%s+", " "):match("^%s*(.-)%s*$") or res
        if caps and fin ~= norm then fin = fin:upper() end
        FastCache[ck] = fin; return fin
    end
    FastCache[ck] = raw; return raw
end

local function applyTrans(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    if inst:GetAttribute("__IsTranslating") or inst:GetAttribute("__HiddenVxLogo") then return end
    if inst.Name == "IslandExpandHint" or inst:FindFirstAncestor("ChilliPro_Expanded") then return end

    if inst:IsA("TextBox") then
        local ph = inst:GetAttribute("OrigPlaceholder")
        if not ph and inst.PlaceholderText ~= "" and not hasVi(inst.PlaceholderText) then
            ph = inst.PlaceholderText
            inst:SetAttribute("OrigPlaceholder", ph)
        end
        if ph then inst.PlaceholderText = translateText(ph) end
        return
    end

    local rt = inst.Text
    local orig = inst:GetAttribute("OrigRawText")
    if not orig then
        if not hasVi(rt) then
            orig = rt
            inst:SetAttribute("OrigRawText", orig)
        else return end
    end
    local mapped = translateText(orig)
    inst:SetAttribute("__LastTranslated", mapped)
    if inst.Text ~= mapped then
        inst:SetAttribute("__IsTranslating", true)
        pcall(function() inst.Text = mapped end)
        inst:SetAttribute("__IsTranslating", false)
    end
end

local function hookTrans(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    if inst.Name == "IslandExpandHint" or inst:FindFirstAncestor("ChilliPro_Expanded") then return end
    applyTrans(inst)
    if inst:GetAttribute("__TransHookSession") == SID then return end
    inst:SetAttribute("__TransHookSession", SID)
    table.insert(State.TrackedTexts, inst)
    inst:GetPropertyChangedSignal("Text"):Connect(function()
        if not isAlive() or inst:GetAttribute("__IsTranslating") or inst:GetAttribute("__HiddenVxLogo") then return end
        if inst:IsA("TextBox") then applyTrans(inst); return end
        local cur = inst.Text
        if cur ~= inst:GetAttribute("__LastTranslated") and not hasVi(cur) then
            inst:SetAttribute("OrigRawText", cur)
            applyTrans(inst)
        end
    end)
end

local function refreshAll()
    task.spawn(function()
        if State.RefreshNoticeCallback then State.RefreshNoticeCallback() end
        local list = State.TrackedTexts
        for i = #list, 1, -1 do
            if not isAlive() then return end
            local el = list[i]
            if el and el.Parent then applyTrans(el) else table.remove(list, i) end
            if i % 80 == 0 then task.wait() end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- PREMIUM NOTICE
-- ═══════════════════════════════════════════════════════════════
local function showNotice()
    if State.NoticeShown then return end
    State.NoticeShown = true
    local parentTarget = (gethui and pcall(gethui) and gethui()) or CoreGui
    local nGui = mk("ScreenGui", {
        Name = "ChilliPro_NoticeGui",
        DisplayOrder = 2147483647,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, parentTarget)

    local ov = mk("Frame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.55,
        Active = true
    }, nGui)

    local md = mk("Frame", {
        Size = UDim2.new(0, 420, 0, 260),
        Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = COLORS.BgPanel,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, ov)
    mk("UICorner", { CornerRadius = UDim.new(0, 16) }, md)
    local st = mk("UIStroke", {
        Thickness = 2,
        Color = Color3.new(1,1,1),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, md)
    table.insert(State.ActiveGradients, mk("UIGradient", { Color = RAINBOW }, st))

    local banner = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = COLORS.BgCard,
        BorderSizePixel = 0
    }, md)
    mk("UICorner", { CornerRadius = UDim.new(0, 16) }, banner)
    local bannerFix = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 1, -16),
        BackgroundColor3 = COLORS.BgCard,
        BorderSizePixel = 0
    }, banner)
    mk("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = COLORS.Gold,
        BorderSizePixel = 0
    }, banner).Parent = banner
    local bgold = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = COLORS.Gold,
        BorderSizePixel = 0
    }, banner)
    table.insert(State.ActiveGradients, mk("UIGradient", { Color = GOLD_GRAD }, bgold))

    local icon = mk("Frame", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 16, 0.5, -20),
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0
    }, banner)
    mk("UICorner", { CornerRadius = UDim.new(0, 10) }, icon)
    table.insert(State.ActiveGradients,
        mk("UIGradient", { Color = GOLD_GRAD, Rotation = 45 }, icon))
    mk("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "🌶",
        TextColor3 = Color3.new(1,1,1),
        TextSize = 22,
        Font = Enum.Font.GothamBold
    }, icon)

    local titleRow = mk("Frame", {
        Size = UDim2.new(1, -70, 0, 22),
        Position = UDim2.new(0, 66, 0, 8),
        BackgroundTransparency = 1
    }, banner)
    local title = mk("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        TextSize = 17,
        TextColor3 = COLORS.Text,
        TextXAlignment = Enum.TextXAlignment.Left
    }, titleRow)

    local subtitle = mk("TextLabel", {
        Size = UDim2.new(1, -70, 0, 18),
        Position = UDim2.new(0, 66, 0, 32),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = COLORS.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left
    }, banner)

    local body = mk("TextLabel", {
        Size = UDim2.new(1, -40, 0, 120),
        Position = UDim2.new(0, 20, 0, 78),
        BackgroundTransparency = 1,
        TextWrapped = true,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(220, 220, 245),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, md)

    local footNote = mk("TextLabel", {
        Size = UDim2.new(1, -40, 0, 18),
        Position = UDim2.new(0, 20, 1, -68),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = COLORS.Gold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, md)

    local closeBtn = mk("TextButton", {
        Size = UDim2.new(0, 140, 0, 34),
        Position = UDim2.new(1, -160, 1, -50),
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.new(1,1,1)
    }, md)
    mk("UICorner", { CornerRadius = UDim.new(0, 8) }, closeBtn)
    table.insert(State.ActiveGradients,
        mk("UIGradient", { Color = RAINBOW, Rotation = 90 }, closeBtn))

    local function syncNotice()
        if State.Language == "VI" then
            title.Text = "CHILLI HUB · PRO"
            subtitle.Text = "Phiên bản cao cấp · Venyx core"
            body.Text = "Đây là Chilli Hub PRO — bản wrapper nâng cấp của Venyx. Mọi tính năng đều đến từ Venyx core, chỉ được làm mới giao diện và bổ sung tiếng Việt.\n\nKhông có backdoor, không có URL lạ, không fake FPS."
            footNote.Text = "Dùng nút VI / EN trên thanh nổi để đổi ngôn ngữ."
            closeBtn.Text = "BẮT ĐẦU"
        else
            title.Text = "CHILLI HUB · PRO"
            subtitle.Text = "Premium Edition · Venyx core"
            body.Text = "This is Chilli Hub PRO — a premium wrapper of Venyx. All features come from the Venyx core; only the UI has been refreshed and Vietnamese added.\n\nNo backdoor, no external URLs, no fake FPS."
            footNote.Text = "Use the VI / EN toggle on the floating bar to change language."
            closeBtn.Text = "GET STARTED"
        end
    end
    syncNotice()
    State.RefreshNoticeCallback = syncNotice
    closeBtn.MouseButton1Click:Connect(function()
        State.RefreshNoticeCallback = nil
        nGui:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- PREMIUM FLOATING BAR
-- ═══════════════════════════════════════════════════════════════
local function setupIsland(statusLbl, venyxGui)
    local pill = statusLbl.Parent
    if not (pill and pill:IsA("GuiObject")) then return end
    statusLbl:SetAttribute("__IslandDone", true)
    for _, ch in ipairs(pill:GetChildren()) do
        if ch:IsA("UIGradient") or ch.Name == "IslandClickHitbox" then ch:Destroy() end
    end

    pill.BackgroundColor3 = COLORS.BgDark
    pill.BackgroundTransparency = 0
    pill.Size = UDim2.new(0,0,0,30)
    pill.AutomaticSize = Enum.AutomaticSize.X
    if not pill:FindFirstChildOfClass("UICorner") then
        mk("UICorner", { CornerRadius = UDim.new(1, 0) }, pill)
    end
    local pillStroke = pill:FindFirstChild("PillStroke") or mk("UIStroke", {
        Name = "PillStroke",
        Thickness = 1.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.new(1,1,1)
    }, pill)
    table.insert(State.ActiveGradients,
        pillStroke:FindFirstChildOfClass("UIGradient")
            or mk("UIGradient", { Color = RAINBOW }, pillStroke))

    local hint = pill:FindFirstChild("IslandExpandHint") or mk("TextLabel", {
        Name = "IslandExpandHint",
        Size = UDim2.new(0,18,0,18),
        BackgroundColor3 = COLORS.BgCard,
        BorderSizePixel = 0,
        Text = "▼",
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = COLORS.Gold,
        LayoutOrder = 99,
        ZIndex = 10000
    }, pill)
    if not hint:FindFirstChildOfClass("UICorner") then
        mk("UICorner", { CornerRadius = UDim.new(1,0) }, hint)
    end

    local function syncStatus(fromSaved)
        if statusLbl:GetAttribute("__Updating") then return end
        statusLbl:SetAttribute("__Updating", true)
        local cur = statusLbl.Text:gsub("●",""):gsub("•",""):match("^%s*(.-)%s*$") or ""
        local en = statusLbl:GetAttribute("OrigStatusEn")
        if not fromSaved and cur ~= "" and cur ~= statusLbl:GetAttribute("__LastTranslatedStatus") and not hasVi(cur) then
            en = cur
            statusLbl:SetAttribute("OrigStatusEn", en)
        end
        if not en or en == "" or hasVi(en) then
            en = "Idle"
            statusLbl:SetAttribute("OrigStatusEn", "Idle")
        end
        local fin = translateStatus(en)
        statusLbl:SetAttribute("__LastTranslatedStatus", fin)
        if statusLbl.Text ~= fin then statusLbl.Text = fin end
        statusLbl.TextColor3 = COLORS.Text
        statusLbl.TextTransparency = 0
        statusLbl:SetAttribute("__Updating", false)
    end
    State.RefreshIslandCallback = function() syncStatus(true) end
    syncStatus(false)

    local exp = venyxGui:FindFirstChild("ChilliPro_Expanded")
    if statusLbl:GetAttribute("__IslandSession") == SID and exp then return end
    statusLbl:SetAttribute("__IslandSession", SID)

    local tg = statusLbl:FindFirstChild("TextRainbow") or mk("UIGradient", {
        Name = "TextRainbow", Color = RAINBOW
    }, statusLbl)
    table.insert(State.ActiveGradients, tg)

    pill.Parent = venyxGui
    pill.AnchorPoint = Vector2.new(0.5, 0)
    pill.ZIndex = 9999
    pill.Active = true
    statusLbl.Active = true
    hint.Active = true
    if pill.Position.Y.Offset < 4 or pill.Position.Y.Offset > 600 then
        pill.Position = UDim2.new(0.5,0,0,10)
    end

    if exp then exp:Destroy() end
    exp = mk("Frame", {
        Name = "ChilliPro_Expanded",
        AnchorPoint = Vector2.new(0.5,0),
        Position = pill.Position,
        Size = UDim2.new(0,300,0,120),
        BackgroundColor3 = COLORS.BgPanel,
        BorderSizePixel = 0,
        Visible = false,
        Active = true,
        ZIndex = 10000
    }, venyxGui)
    mk("UICorner", { CornerRadius = UDim.new(0,18) }, exp)
    local es = mk("UIStroke", {
        Thickness = 1.8,
        Color = Color3.new(1,1,1),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, exp)
    table.insert(State.ActiveGradients, mk("UIGradient", { Color = RAINBOW }, es))

    local headerBar = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = COLORS.BgCard,
        BorderSizePixel = 0
    }, exp)
    mk("UICorner", { CornerRadius = UDim.new(0, 18) }, headerBar)

    local logoDot = mk("Frame", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, 12, 0.5, -11),
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0
    }, headerBar)
    mk("UICorner", { CornerRadius = UDim.new(1,0) }, logoDot)
    table.insert(State.ActiveGradients,
        mk("UIGradient", { Color = GOLD_GRAD, Rotation = 45 }, logoDot))
    mk("TextLabel", {
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,
        Text = "🌶",
        TextColor3 = Color3.new(1,1,1),
        TextSize = 12,
        Font = Enum.Font.GothamBold
    }, logoDot)

    mk("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 42, 0, 0),
        BackgroundTransparency = 1,
        Text = "CHILLI HUB · PRO",
        Font = Enum.Font.GothamBlack,
        TextSize = 12,
        TextColor3 = COLORS.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10001
    }, headerBar)

    local closeBtn = mk("TextButton", {
        Size = UDim2.new(0, 26, 0, 22),
        Position = UDim2.new(1, -34, 0.5, -11),
        BackgroundColor3 = COLORS.BgDark,
        BorderSizePixel = 0,
        Text = "▲",
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = COLORS.Gold,
        ZIndex = 10002
    }, headerBar)
    mk("UICorner", { CornerRadius = UDim.new(1,0) }, closeBtn)

    local langRow = mk("Frame", {
        Size = UDim2.new(1, -24, 0, 38),
        Position = UDim2.new(0, 12, 0, 42),
        BackgroundColor3 = COLORS.BgDark,
        BorderSizePixel = 0,
        ZIndex = 10001
    }, exp)
    mk("UICorner", { CornerRadius = UDim.new(1,0) }, langRow)

    local slider = mk("Frame", {
        Size = UDim2.new(0.5, -3, 1, -6),
        Position = (State.Language == "VI") and UDim2.new(0, 3, 0, 3) or UDim2.new(0.5, 3, 0, 3),
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        ZIndex = 10002
    }, langRow)
    mk("UICorner", { CornerRadius = UDim.new(1,0) }, slider)
    table.insert(State.ActiveGradients,
        mk("UIGradient", { Color = RAINBOW, Rotation = 90 }, slider))

    local bVI = mk("TextButton", {
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "🇻🇳 TIẾNG VIỆT",
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = (State.Language == "VI") and Color3.new(1,1,1) or COLORS.TextDim,
        ZIndex = 10003
    }, langRow)
    local bEN = mk("TextButton", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "🌐 ENGLISH",
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = (State.Language == "EN") and Color3.new(1,1,1) or COLORS.TextDim,
        ZIndex = 10003
    }, langRow)

    local tagline = mk("TextLabel", {
        Size = UDim2.new(1, -24, 0, 26),
        Position = UDim2.new(0, 12, 1, -34),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextColor3 = COLORS.Gold,
        TextXAlignment = Enum.TextXAlignment.Center,
        Text = (State.Language == "VI") and "★ Phiên bản cao cấp · Venyx core ★" or "★ Premium Edition · Venyx core ★",
        ZIndex = 10001
    }, exp)

    local function setLang(l)
        if State.Language == l then return end
        State.Language = l
        TweenService:Create(slider, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
            Position = (l == "VI") and UDim2.new(0,3,0,3) or UDim2.new(0.5,3,0,3)
        }):Play()
        bVI.TextColor3 = (l == "VI") and Color3.new(1,1,1) or COLORS.TextDim
        bEN.TextColor3 = (l == "EN") and Color3.new(1,1,1) or COLORS.TextDim
        tagline.Text = (l == "VI") and "★ Phiên bản cao cấp · Venyx core ★" or "★ Premium Edition · Venyx core ★"
        refreshAll()
    end
    bVI.MouseButton1Click:Connect(function() setLang("VI") end)
    bEN.MouseButton1Click:Connect(function() setLang("EN") end)

    local function toggleExp(open)
        if open then
            exp.Position = pill.Position
            pill.Visible = false
            exp.Size = UDim2.new(0,180,0,32)
            exp.Visible = true
            TweenService:Create(exp, TweenInfo.new(0.28, Enum.EasingStyle.Quart), {
                Size = UDim2.new(0,300,0,120)
            }):Play()
        else
            pill.Position = exp.Position
            exp.Visible = false
            pill.Visible = true
        end
    end
    closeBtn.MouseButton1Click:Connect(function() toggleExp(false) end)

    local function bindDrag(trig, mv, tap)
        if trig:GetAttribute("__DragSession") == SID then return end
        trig:SetAttribute("__DragSession", SID)
        local drag, dStart, sPos, moved = false, nil, nil, false
        trig.InputBegan:Connect(function(inp)
            if not isAlive() then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                drag, moved, dStart, sPos = true, false, inp.Position, mv.Position
                inp.Changed:Connect(function()
                    if inp.UserInputState == Enum.UserInputState.End then
                        if drag and not moved and tap then tap() end
                        drag = false
                    end
                end)
            end
        end)
        trig.InputChanged:Connect(function(inp)
            if not isAlive() or not drag then return end
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                local d = inp.Position - dStart
                if d.Magnitude > 6 then moved = true end
                local cam = workspace.CurrentCamera
                local mx = cam and cam.ViewportSize.X - 140 or 800
                local my = cam and cam.ViewportSize.Y - 50 or 600
                local np = UDim2.new(
                    sPos.X.Scale,
                    math.clamp(sPos.X.Offset + d.X, -mx/2, mx/2),
                    sPos.Y.Scale,
                    math.clamp(sPos.Y.Offset + d.Y, 4, my)
                )
                pill.Position = np
                exp.Position = np
            end
        end)
    end
    local openFn = function() toggleExp(true) end
    bindDrag(pill, pill, openFn)
    bindDrag(statusLbl, pill, openFn)
    bindDrag(hint, pill, openFn)
    bindDrag(exp, exp, nil)

    statusLbl:GetPropertyChangedSignal("Text"):Connect(function()
        if isAlive() and not statusLbl:GetAttribute("__Updating")
            and statusLbl.Text ~= statusLbl:GetAttribute("__LastTranslatedStatus") then
            syncStatus(false)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- PREMIUM LOGO
-- ═══════════════════════════════════════════════════════════════
local function setupCircleLogo(obj)
    local top = obj
    while top.Parent and top.Parent:IsA("GuiObject") and not top.Parent:IsA("ScreenGui") do
        top = top.Parent
    end
    if top:GetAttribute("__ChilliLogo") then return end
    local sz, pos = top.AbsoluteSize, top.AbsolutePosition
    if sz.X > 105 or sz.Y > 105 or sz.X < 28 or math.abs(sz.X - sz.Y) > 25 or pos.X > 350 then return end
    top:SetAttribute("__ChilliLogo", true)

    for _, ch in ipairs(top:GetDescendants()) do
        if (ch:IsA("UIPadding") or ch:IsA("UIAspectRatioConstraint") or ch:IsA("UISizeConstraint"))
            and ch.Name ~= "PerfectCircleAspect" then
            pcall(ch.Destroy, ch)
        end
        if (ch:IsA("ImageLabel") or ch:IsA("ImageButton")) and ch.Name ~= "ChilliCoverLogo" then
            ch.ImageTransparency = 1
            ch.BackgroundTransparency = 1
        elseif ch:IsA("TextLabel") or ch:IsA("TextButton") then
            ch:SetAttribute("__HiddenVxLogo", true)
            ch.TextTransparency = 1
            ch.BackgroundTransparency = 1
        end
    end
    if top:IsA("ImageLabel") or top:IsA("ImageButton") then
        top.ImageTransparency = 1
    elseif top:IsA("TextLabel") or top:IsA("TextButton") then
        top:SetAttribute("__HiddenVxLogo", true)
        top.TextTransparency = 1
    end

    top.Size = UDim2.new(0, 64, 0, 64)
    top.BackgroundColor3 = COLORS.BgDark
    top.BackgroundTransparency = 0
    top.BorderSizePixel = 0
    top.ClipsDescendants = true
    if not top:FindFirstChild("PerfectCircleAspect") then
        mk("UIAspectRatioConstraint", { Name = "PerfectCircleAspect", AspectRatio = 1 }, top)
    end
    if not top:FindFirstChildOfClass("UICorner") then
        mk("UICorner", { CornerRadius = UDim.new(1,0) }, top)
    end
    local st = top:FindFirstChild("RainbowBorder") or mk("UIStroke", {
        Name = "RainbowBorder",
        Thickness = 3,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.new(1,1,1)
    }, top)
    table.insert(State.ActiveGradients,
        st:FindFirstChildOfClass("UIGradient") or mk("UIGradient", { Color = RAINBOW }, st))
    local cov = top:FindFirstChild("ChilliCoverLogo") or mk("ImageLabel", {
        Name = "ChilliCoverLogo",
        Size = UDim2.new(1,0,1,0),
        Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,
        Image = LOGO_ID,
        ScaleType = Enum.ScaleType.Fit,
        Active = false,
        ZIndex = top.ZIndex + 5
    }, top)
    if not cov:FindFirstChildOfClass("UICorner") then
        mk("UICorner", { CornerRadius = UDim.new(1,0) }, cov)
    end
end

local function patchHeaderLogo(win, titleLbl)
    local hy, tx = titleLbl.AbsolutePosition.Y, titleLbl.AbsolutePosition.X
    for _, it in ipairs(win:GetDescendants()) do
        if it ~= titleLbl and it:IsA("GuiObject") and it.Name ~= "ChilliHeaderLogo" then
            local p, s = it.AbsolutePosition, it.AbsoluteSize
            if math.abs(p.Y - hy) < 35 and p.X < tx and s.X >= 10 and s.X <= 45 then
                if it:IsA("ImageLabel") or it:IsA("ImageButton") then
                    it.Image = LOGO_ID
                    it.ImageTransparency = 0
                    it.BackgroundTransparency = 1
                    it.ScaleType = Enum.ScaleType.Fit
                elseif it:IsA("TextLabel") or it:IsA("TextButton") then
                    it:SetAttribute("__HiddenVxLogo", true)
                    it.TextTransparency = 1
                    if it.Parent and not it.Parent:FindFirstChild("ChilliHeaderLogo") then
                        mk("ImageLabel", {
                            Name = "ChilliHeaderLogo",
                            Size = UDim2.new(0,26,0,26),
                            Position = UDim2.new(0.5,0,0.5,0),
                            AnchorPoint = Vector2.new(0.5,0.5),
                            BackgroundTransparency = 1,
                            Image = LOGO_ID,
                            ScaleType = Enum.ScaleType.Fit,
                            ZIndex = it.ZIndex + 2
                        }, it.Parent)
                    end
                end
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- PATCH VENYX GUI
-- ═══════════════════════════════════════════════════════════════
local venyxGuiLocked = nil

local function patchVenyxGui(gui, titleLbl)
    pcall(function() gui.Enabled = true end)
    if titleLbl.Text ~= NEW_TITLE then
        titleLbl:SetAttribute("__IsTranslating", true)
        titleLbl.Text = NEW_TITLE
        titleLbl.AutomaticSize = Enum.AutomaticSize.X
        titleLbl:SetAttribute("__IsTranslating", false)
    end

    local win, curr = nil, titleLbl
    while curr.Parent and curr.Parent ~= gui do
        curr = curr.Parent
        if curr:IsA("GuiObject") and curr.AbsoluteSize.X >= 350 and curr.AbsoluteSize.Y >= 220 then
            win = curr
        end
    end
    if win then
        pcall(function() win.Visible = true end)
        if not win:GetAttribute("__ChilliStyled") then
            win:SetAttribute("__ChilliStyled", true)
            pcall(function()
                if win:IsA("Frame") and win:FindFirstChildOfClass("UIStroke") then
                    local s = win:FindFirstChildOfClass("UIStroke")
                    s.Color = COLORS.BorderHi
                    s.Thickness = 1.5
                end
            end)
        end
    end

    local hy = titleLbl.AbsolutePosition.Y
    if win then patchHeaderLogo(win, titleLbl) end
    for _, tc in ipairs(gui:GetChildren()) do
        if tc:IsA("GuiObject") and tc ~= win
            and tc.Name ~= "ChilliPro_Expanded"
            and not tc:FindFirstChild("IslandExpandHint") then
            setupCircleLogo(tc)
        end
    end

    local queue = {}
    for _, d in ipairs(gui:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
            local txt = d.Text or ""
            local hasDot = false
            if d.Parent and d.Parent:IsA("GuiObject") and d.Parent.AbsoluteSize.X < 320 then
                for _, sb in ipairs(d.Parent:GetChildren()) do
                    if sb:IsA("Frame") and sb.AbsoluteSize.X <= 14 and sb.AbsoluteSize.Y <= 14 then
                        hasDot = true
                        break
                    end
                end
            end
            local isStatus = (not gui:GetAttribute("__IslandLocked"))
                and (not d:FindFirstAncestorOfClass("ScrollingFrame"))
                and d.Parent and (not titleLbl:IsDescendantOf(d.Parent))
                and math.abs(d.AbsolutePosition.Y - hy) < 35
                and d.AbsolutePosition.X > titleLbl.AbsolutePosition.X + 60
                and (hasDot or txt:lower():find("idle", 1, true) or txt == "Đang rảnh")
                and not txt:find("v1.", 1, true)
            if isStatus or d:GetAttribute("__IslandDone") then
                gui:SetAttribute("__IslandLocked", true)
                setupIsland(d, gui)
            elseif d:GetAttribute("__TransHookSession") ~= SID then
                queue[#queue + 1] = d
            end
        elseif (d:IsA("ImageLabel") or d:IsA("ImageButton"))
            and d.Name ~= "ChilliCoverLogo"
            and d.Name ~= "ChilliHeaderLogo" then
            if not d:FindFirstAncestorOfClass("ScrollingFrame") and win and not d:IsDescendantOf(win) then
                setupCircleLogo(d)
            end
        end
    end

    if #queue > 0 and not gui:GetAttribute("__BatchTranslating") then
        gui:SetAttribute("__BatchTranslating", true)
        task.spawn(function()
            for i = 1, #queue do
                if not isAlive() then break end
                if queue[i] and queue[i].Parent then hookTrans(queue[i]) end
                if i % 80 == 0 then task.wait() end
            end
            gui:SetAttribute("__BatchTranslating", false)
        end)
    end
end

local function bindGuiEvents(gui)
    if not gui:IsA("ScreenGui") or IGNORED_GUIS[gui.Name] or gui:GetAttribute("__ListenerSession") == SID then return end
    gui:SetAttribute("__ListenerSession", SID)
    gui.DescendantAdded:Connect(function(nd)
        if not isAlive() then return end
        if nd:IsA("TextLabel") or nd:IsA("TextButton") or nd:IsA("TextBox") then
            task.defer(function() if isAlive() then hookTrans(nd) end end)
        elseif (nd:IsA("ImageLabel") or nd:IsA("ImageButton")) and gui == venyxGuiLocked then
            task.defer(function()
                if isAlive() and not nd:FindFirstAncestorOfClass("ScrollingFrame") then
                    setupCircleLogo(nd)
                end
            end)
        end
    end)
end

local function scanOnce()
    if not isAlive() then return false end
    for _, root in ipairs(getScanRoots()) do
        local guis = {}
        for _, ch in ipairs(root:GetChildren()) do
            if ch:IsA("ScreenGui") then
                table.insert(guis, ch)
            elseif ch:IsA("Folder") then
                for _, sub in ipairs(ch:GetChildren()) do
                    if sub:IsA("ScreenGui") then table.insert(guis, sub) end
                end
            end
        end
        for _, gui in ipairs(guis) do
            if not IGNORED_GUIS[gui.Name] then
                bindGuiEvents(gui)
                local titleLbl = nil
                for _, d in ipairs(gui:GetDescendants()) do
                    if d:IsA("TextLabel") or d:IsA("TextButton") then
                        local t = d.Text
                        if (t == "VENYX" or t == "Venyx" or t == NEW_TITLE)
                            and not d:FindFirstAncestorOfClass("ScrollingFrame") then
                            titleLbl = d
                        end
                    end
                end
                if titleLbl then
                    venyxGuiLocked = gui
                    patchVenyxGui(gui, titleLbl)
                end
            end
        end
    end
    return venyxGuiLocked ~= nil
end

for _, root in ipairs(getScanRoots()) do
    root.DescendantAdded:Connect(function(ch)
        if isAlive() and ch:IsA("ScreenGui") and not IGNORED_GUIS[ch.Name] then
            bindGuiEvents(ch)
            task.wait(0.15)
            pcall(scanOnce)
        end
    end)
end

pcall(scanOnce)
task.spawn(function()
    local t = 0
    while isAlive() and not venyxGuiLocked and t < 60 do
        task.wait(0.35)
        t = t + 0.35
        if t > 4.5 and not venyxGuiLocked then launchVenyx() end
        pcall(scanOnce)
    end
    if isAlive() then
        showNotice()
        task.wait(1.0)
        pcall(scanOnce)
    end
end)

task.spawn(function()
    local rot = 0
    while isAlive() do
        rot = (rot + 5) % 360
        local grads = State.ActiveGradients
        for i = #grads, 1, -1 do
            local g = grads[i]
            if g and g.Parent then g.Rotation = rot else table.remove(grads, i) end
        end
        task.wait(0.033)
    end
end)

print("[Chilli Hub PRO] Đã tải · Venyx core: " .. VENYX_URL)
print("[Chilli Hub PRO] Ngôn ngữ: " .. State.Language .. " · Không lưu file · Không backdoor")