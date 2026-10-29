
blue() {
  # Kiểm tra xem máy đã cài blueutil chưa
  if ! command -v blueutil &> /dev/null; then
    echo "Lỗi: Lệnh này cần 'blueutil' để hoạt động trên macOS."
    echo "Anh vui lòng chạy lệnh sau để cài đặt: brew install blueutil"
    return 1
  fi

  # Lấy trạng thái hiện tại của Bluetooth (1 là On, 0 là Off)
  local state=$(blueutil -p)

  if [[ -z "$1" ]]; then
    # Không có hậu tố: Toggle (đang On -> Off, đang Off -> On)
    if [[ "$state" == "1" ]]; then
      blueutil -p 0
      echo "Bluetooth đang BẬT ➔ Đã TẮT."
    else
      blueutil -p 1
      echo "Bluetooth đang TẮT ➔ Đã BẬT."
    fi

  elif [[ "$1" == "1" ]]; then
    # Hậu tố 1: Bật Bluetooth
    if [[ "$state" == "1" ]]; then
      echo "Bluetooth hiện đã BẬT sẵn."
    else
      blueutil -p 1
      echo "Đã BẬT Bluetooth."
    fi

  elif [[ "$1" == "0" ]]; then
    # Hậu tố 0: Tắt Bluetooth
    if [[ "$state" == "0" ]]; then
      echo "Bluetooth hiện đã TẮT sẵn."
    else
      blueutil -p 0
      echo "Đã TẮT Bluetooth."
    fi

  else
    # Sai hậu tố
    echo "Hậu tố không hợp lệ. Hướng dẫn sử dụng:"
    echo "  blue    : Chuyển đổi trạng thái (Toggle) Bluetooth"
    echo "  blue 1  : Bật Bluetooth"
    echo "  blue 0  : Tắt Bluetooth"
  fi
}


# Hàm quét và kết nối Bluetooth cho macOS (yêu cầu: brew install blueutil)
function bluescan() {
    # Kiểm tra lệnh blueutil
    if ! command -v blueutil &> /dev/null; then
        echo "❌ Lỗi: Không tìm thấy lệnh 'blueutil'."
        echo "👉 Anh cần chạy lệnh này trước: brew install blueutil"
        return 1
    fi

    # Bật Bluetooth nếu nó đang tắt
    if [[ "$(blueutil --power)" == "0" ]]; then
        echo "🔄 Đang bật Bluetooth..."
        blueutil --power 1
        sleep 2
    fi

    while true; do
        echo "🔄 Đang lấy danh sách các thiết bị đã từng ghép nối (Paired Devices)..."
        
        # Lấy danh sách thiết bị
        local devices_output="$(blueutil --paired)"
        
        if [[ -z "$devices_output" ]]; then
            echo "⚠️ Không tìm thấy thiết bị nào."
        fi

        local macs=()
        local names=()
        local index=1

        echo "\n📡 DANH SÁCH THIẾT BỊ BLUETOOTH:"
        # Phân tích từng dòng kết quả
        for line in "${(@f)devices_output}"; do
            if [[ -n "$line" ]]; then
                # Lấy địa chỉ MAC (định dạng xx-xx-xx-xx-xx-xx)
                local mac=$(echo "$line" | grep -oE '([0-9a-fA-F]{2}-){5}[0-9a-fA-F]{2}' | head -n 1)
                # Lấy Tên thiết bị (nằm trong cặp dấu ngoặc kép sau chữ name: )
                local name=$(echo "$line" | sed -n 's/.*name: "\([^"]*\)".*/\1/p')
                
                if [[ -n "$mac" && -n "$name" ]]; then
                    macs[$index]=$mac
                    names[$index]=$name
                    
                    # Đã đổi tên biến 'status' thành 'conn_status' để tránh xung đột với hệ thống zsh
                    if echo "$line" | grep -q "not connected"; then
                        local conn_status="⚪ Ngắt kết nối"
                    else
                        local conn_status="🟢 Đang kết nối"
                    fi

                    echo "  $index) $name [$mac] - $conn_status"
                    ((index++))
                fi
            fi
        done

        echo "  0) 🔄 Quét lại lần nữa"
        echo "  q) ❌ Thoát"
        
        echo "------------------------------------------------"
        local choices
        read "choices?👉 Nhập số thiết bị để kết nối (vd: 1 2 5), chọn 0 để quét lại: "

        if [[ "$choices" == "0" ]]; then
            echo "\n"
            continue
        elif [[ "$choices" == "q" || "$choices" == "Q" ]]; then
            echo "Đã thoát chương trình."
            return 0
        fi

        local selected_indices=($=choices)

        echo "\n"
        for sel in $selected_indices; do
            if [[ $sel -ge 1 && $sel -lt $index ]]; then
                local target_mac="${macs[$sel]}"
                local target_name="${names[$sel]}"
                
                echo "⏳ Đang thử kết nối với: $target_name [$target_mac]..."
                
                # Gọi blueutil để kết nối
                blueutil --connect "$target_mac"
                sleep 2 # Đợi 2s để Mac thiết lập kết nối
                
                # Kiểm tra xem có kết nối thành công không (1 là có, 0 là không)
                local is_connected=$(blueutil --is-connected "$target_mac")
                
                if [[ "$is_connected" == "1" ]]; then
                    echo "✅ Kết nối THÀNH CÔNG: $target_name"
                    
                    # Lấy thông tin pin qua system_profiler
                    local battery=$(system_profiler SPBluetoothDataType 2>/dev/null | grep -A 15 "$target_name" | grep -i "Battery Level:" | head -n 1 | awk '{print $3}')
                    [[ -z "$battery" ]] && battery="Không hỗ trợ xem pin qua CLI" 
                    
                    echo "   📌 Tên thiết bị : $target_name"
                    echo "   🔋 Trạng thái pin: $battery"
                    echo "------------------------------------------------"
                else
                    echo "❌ Kết nối thất bại với $target_name. Hãy chắc chắn thiết bị đang bật và ở gần."
                    echo "------------------------------------------------"
                fi
            else
                echo "⚠️ Lựa chọn '$sel' không hợp lệ. Bỏ qua."
            fi
        done

        break
    done
}