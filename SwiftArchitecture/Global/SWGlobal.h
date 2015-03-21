//
//  SWGlobal.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved
//

#ifndef SwiftArchitecture_SWGlobal_h
#define SwiftArchitecture_SWGlobal_h

#define UPER_DATA_COUNT 10
#define dataHasChanged @"dataHasChanged"
#define CacheFoder @"CacheFoder"

/*TYPE ENUM*/
typedef enum {
    color = 0,
    category,
    size,
    material
}TableViewType;

typedef enum{
    register_new = 0,
    edit_infor
}UserType;

typedef enum {
    addClother = 0,
    addClotherDetail
}TypeCategory;

typedef enum {
    newClothe = 0,
    detailClothe
}TypeClothe;

typedef enum {
    jean = 0,
    skirt,
    shoe
}TypeChooseClothe;


typedef enum {
    detail = 0,
    choose
}TypeWardrobe;

/*URL*/

#define URL_BASE @"http://localhost/LuaChonTrangPhuc/index.php/api/"
#define URL_IMAGE @"http://localhost/LuaChonTrangPhuc/"
#define URL_LOGIN @"users/api_login"
#define URL_REGISTER @"users/api_register"
#define URL_UPDATE_USER @"users/api_updateUser"
#define URL_WARDROBE_CATEGORY @"wardrobe/api_WardrobeByCategory"
#define URL_WARDROBE_DETAIL @"wardrobe/api_WardrobeDetail"
#define URL_HISTORY @"history/api_insertHistory"
#define URL_LIST_HISTORY @"history/api_allHistory"
#define URL_HISTORYID @"history/api_historyByHistoryId"
#define URL_FEEL @"history/api_updateHistory"
#define URL_UPLOAD_AVARTAR @"users/api_updateAvatar"
#define URL_ADD_WARDROBE @"wardrobe/api_insertWardrobe"
#define URL_SUGGEST_BY_CATEGORYID @"wardrobe/api_WardrobeCountByCategoryId"
#define URL_SUGGEST_BY_CATEGORYID_COLORID @"wardrobe/api_WardrobeCountByCategoryIdAndColorId"


/*TITLE*/
#define Register_Title @"Đăng ký"
#define Login_Title @"Đăng nhập"
#define DressTime_Title @"Lựa chọn trang phục"
#define Wardrobe_Title @"Bộ sưu tập"
#define AddClothe_Title @"Thêm mới"
#define DetailClothe_Title @"Thông tin trang phục"
#define Log_Title @"Lịch sử"
#define Feel_Title @"Cảm nhận"
#define Setting_Title @"Cài đặt"
#define InforUser_Title @"Thông tin của bạn"
#define About_Title @"Thông tin ứng dụng"

/*TEXT*/
#define First_Name_Message @"Mời bạn nhập họ!"
#define Last_Name_Message @"Mời bạn nhập tên!"
#define Height_Message @"Mời bạn nhập chiều cao!"
#define Height_Error_Message @"Mời bạn nhập lại chiều cao!"
#define Weight_Message @"Mời bạn nhập cân nặng!"
#define Weight_Error_Message @"Mời bạn nhập lại cân nặng!"
#define Telephone_Message @"Số điện thoại không đúng!"
#define Email_Message @"Email không tồn tại!"
#define Password_Message @"Mật khẩu của bạn chưa đủ kí tự"
#define Re_Password_Message @"Mật khẩu chưa đúng"
#define Complete_Button @"Hoàn thành"
#define Register_Button @"Đăng ký"

#define Dress_Time_Title @"Lựa chọn"
#define Wardrobe_Title @"Bộ sưu tập"
#define Log_Title @"Lịch sử"
#define Setting_Title @"Cài đặt"
#define Skirt @"ÁO"
#define Jeans @"QUẦN/VÁY"
#define Shoe @"GIÀY/DÉP"
#define Cell @"Cell"

#define Title_ActionSheet @"Chọn ảnh"
#define Cancel_ActionSheet @"Thoát"
#define TakePhoto_ActionSheet @"Chụp ảnh"
#define PhotoLibrary_ActionSheet @"Chọn từ thư viện"
#define Message_Camera @"Thiết bị không có camera"
#define Title_Alert @"Xác nhận"
#define Title_Alert_Validate @"Thông báo"
#define Message_Alert @"Bạn có chắc chắn thêm mới không?"
#define Message_Alert_Validate @"Bạn chưa nhập tên trang phục!"
#define Message_Alert_Camera @"Bạn chưa có ảnh trang phục"
#define Cancel @"Không"
#define Yes @"Có"
#define OK_Button @"OK"
#define Register_message_success @"Đăng ký thành công"
#define Register_message_fail @"Đăng ký không thành công"
#define Email_existed_message @"Email đã được đăng ký"

#define Date_Format @"eee dd/MM/yyyy"
#define Time_Format @"hh:mm a"
#define DateTime_Format @"hh:mm a eee dd/MM/yyyy"

/*IMAGE*/
#define Back_Button @"back_green.png"
#define Dress_Time_On @"t_shirt_on.png"
#define Dress_Time_Off @"t_shirt_off.png"
#define Wardrobe_On @"wardrobe_on.png"
#define Wardrobe_Off @"wardrobe_off.png"
#define Log_On @"bookmark_on.png"
#define Log_Off @"bookmark_off.png"
#define Setting_On @"settings_filled.png"
#define Setting_Off @"settings_off.png"
#define Search @"search.png"
#define Add @"plus.png"
#define Check_Mark @"checkmark.png"
#define Up @"up4.png"
#define Down @"down.png"
#define Edit @"edit_green.png"

#define Gray_Weather @"_gray.png"
#define Red_Weather @"_red.png"

/*COLOR*/
#define Gray_Color @"939393"
#define Button_bg @"EAEAEA"
#define Button_bg_Selected @"40CCBB"
#define White_Color @"FFFFFF"
#define Black_Color @"000000"
#define Green_Color @"40CCBB"
#define Red_Color @"F65D63"

/*ARRAY*/
#define Clothes_Arr @[@"Áo sơ mi",@"Áo phông",@"Áo khoác",@"Áo len",@"Quần/Chân váy",@"Váy",@"Giày thể thao",@"Giày hài",@"Giày bốt"]
#define Clothes_IconArr @[@"shirt_red.png",@"t_shirt_red.png",@"coat_red.png",@"jacket_red.png",@"trousers_red.png",@"skirt_red.png",@"trainers_red.png",@"shoe_woman_red.png",@"winter_boots_red.png"]
#define Color_Arr @[@"Đỏ",@"Cam",@"Hồng",@"Vàng",@"Trắng",@"Kem",@"Đen",@"Xám",@"Nâu",@"Ghi",@"Bạc",@"Xanh"]
#define Size_Clothes_Arr @[@"S",@"M",@"L",@"XL",@"XXL"]
#define Size_Shoes_Arr @[@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44"]
#define Size_Jean_Arr @[@"26",@"27",@"28",@"29",@"30",@"31",@"32"]
#define Material_Clothes_Arr @[@"Vải",@"Bò",@"Da",@"Cotton",@"Len"]
#define Material_Shoes_Arr @[@"Vải",@"Da"]


/*CATEGORY*/

#define Aosomi 1
#define Aophong 2
#define Aokhoac 3
#define Aolen 4
#define Quan 5
#define Vay 6
#define Giaythethao 7
#define Giayhai 8
#define Giaybot 9


/*COLOR*/

#define First_Name 0
#define Last_Name 1
#define Gender 2
#define Birthday 3
#define Height 4
#define Weight 5
#define Telephone 6
#define Email 7
#define Password 8
#define Re_Password 9


#endif
