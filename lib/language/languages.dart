abstract class BaseLanguage {
  String get settings;
  String get language;
  String get textScale;
  String get palette;
  String get notificationSetting;
  String get sound;
  String get overlay;
  String get premium;
  String get rateUs;
  String get pravicy;
  String get terms;
  String get archieves;
  String get favourites;
  String get noArchieves;
  String get noFavourites;
  String get floppyNote;
  String get activated;
  String get themes;

  // Tab
  String get keepNote;
  String get todo;

  // Note Dialog Language
  String get addingNote;
  String get caption;
  String get keepYourNoteHere;
  String get chooseColor;
  String get canEditLater;
  String get add;
  String get edit;

  // Note List Page Language
  String get noKeepNote;

  // Note Page Language
  String get setAlarm;
  String get dueTime;
  String get notiTitle;
  String get notiBody;
  String get close;
  String get archieve;
  String get unArchieve;
  String get favourite;
  String get share;
  String get sharePhoto;
  String get shareText;
  String get textBrigthness;
  String get addImage;
  String get notification;

  // Task Dialog Langugae
  String get addingTask;
  String get taskName;
  String get taskDescription;

  // Task Page Language
  String get noTask;
  String get completed;

  // Task Group Dialog Language
  String get addingGroupTask;
  String get groupName;

  // Edit Task
  String get editTask;
  String get advancedOption;
  String get remainder;
  String get attachedNotes;
  String get successfullyEdited;

  // Notification
  String get heyBuddy;

  // Dialog
  String get confirm;
  String get areYourSureToDelete;
  String get setRemainder;
  String get notiMoveToNextDay;

  // Validation
  String get captionIsRequired;
  String get taskNameIsRequired;
  String get notiTitleIsRequired;
  String get notiBodyIsRequried;
  String get groupNameIsRequred;
}

class MyanmarLanguage extends BaseLanguage {
  @override
  String get settings => "ပြင်ဆင်ခန်း";

  @override
  String get language => "ဘာသာစကား";

  @override
  String get palette => "အရောင်များ";

  @override
  String get textScale => "စာလုံး အရွယ်အစား";

  @override
  String get notification => "နိုတီဖီကေးရှင်း ပြင်ဆင်ခန်း";

  @override
  String get addingNote => "မှတ်စု ဖန်တီးခြင်း";

  @override
  String get addingTask => "လုပ်ဆောင်ချက် ဖန်တီးခြင်း";

  @override
  String get taskName => "လုပ်ဆောင်ချက် နာမည်";

  @override
  String get add => "ဖန်တီးမည်";

  @override
  String get canEditLater => "အချိန်ရမှ အသေးစိတ်ရေးသားနိုင်ပါသည်";

  @override
  String get caption => "မှတ်စု ခေါင်းစဥ်";

  @override
  String get chooseColor => "နှစ်သက်ရာ အရောင်ကိုရွေးချက်ပါ";

  @override
  String get keepYourNoteHere => "သင်၏ မှတ်စုကို ဤနေရာတွင် စတင်ရေးသားပါ";

  @override
  String get noKeepNote => "ရေးမှတ်ထားသော မှတ်စုမရှိပါ";

  @override
  String get addingGroupTask => "လုပ်ဆောင်ချက် အစုအဝေး ဖန်တီးခြင်း";

  @override
  String get groupName => "လုပ်ဆောင်ရန် အစုအစည်း နာမည်";

  @override
  String get noTask => "လုပ်ဆောင်ရန် မရှိပါ";

  @override
  String get taskDescription => "အကြောင်းအရာ";

  @override
  String get edit => "ပြင်ဆင်မည်";

  @override
  String get keepNote => "မှတ်စုများ";

  @override
  String get advancedOption => "အခြားသော ရွေးချယ်မှုများ";

  @override
  String get attachedNotes => "တွဲ၍ မှတ်သားထားသော မှတ်စုများ";

  @override
  String get editTask => "လုပ်ဆောင်ချက်ကို ပြင်ဆင်မွန်းမံခြင်း";

  @override
  String get remainder => "အသိပေး အကြောင်းကြားရန်";

  @override
  String get successfullyEdited => "ပြင်ဆင်မွန်းမံပြီးပါပြီ";

  @override
  String get completed => "ပြီးမြောက်ခဲ့သည်";

  @override
  String get areYourSureToDelete => "ဖျက်သိမ်းရန် သေချာပါသည်";

  @override
  String get confirm => "သတိပြုစေခြင်း";

  @override
  String get heyBuddy => "လုပ်ဆောင်ချက် ဆောင်ရွက်ရန် ";

  @override
  String get setRemainder => "အသိပေးချက်ကို ဖန်တီးပြီးပါပြီ";

  @override
  String get archieve => "သိမ်းဆည်းမည်";

  @override
  String get close => "ပိတ်မည်";

  @override
  String get dueTime => "သတ်မှတ်ထားသော အချိန်";

  @override
  String get favourite => "မှတ်သားထားမည်";

  @override
  String get notiBody => "အသိပေးချက်";

  @override
  String get notiTitle => "ခေါင်းစဥ်";

  @override
  String get pravicy => "Pravicy Policy";

  @override
  String get premium => "ပရီမီယမ်";

  @override
  String get rateUs => "မှတ်ချက်ပေးရန်";

  @override
  String get setAlarm => "အသိပေးရန် ";

  @override
  String get share => "မျှဝေမည်";

  @override
  String get sharePhoto => "ပုံကို မျှဝေမည်";

  @override
  String get shareText => "စာသားကို မျှ‌ဝေမည်";

  @override
  String get terms => "Terms Of Services";

  @override
  String get unArchieve => "မသိမ်းဆည်တော့ပါ";

  @override
  String get archieves => "သိမ်းဆည်း မှတ်စုများ";

  @override
  String get captionIsRequired => "ခေါင်းစဥ် လိုအပ်ပါသည်";

  @override
  String get favourites => "နှစ်သက် မှတ်စုများ";

  @override
  String get groupNameIsRequred => "အမည်လိုအပ်ပါသည်";

  @override
  String get notiBodyIsRequried => "အကြောင်းအရာ လိုအပ်ပါသည်";

  @override
  String get notiTitleIsRequired => "ခေါင်းစဥ် လိုအပ်ပါသည်";

  @override
  String get taskNameIsRequired => "အမည်လိုအပ်ပါသည်";

  @override
  String get noArchieves => "သိမ်းဆည်းထားသော မှတ်စုမရှိသေးပါ";

  @override
  String get noFavourites => "မှတ်သားထားသော မှတ်စုမရှိ‌သေးပါ";

  @override
  String get activated => "စတင်ထားသည်";

  @override
  String get addImage => "ပုံ ထည့်သွင်းမည်";

  @override
  String get floppyNote => "ပြင်ပ မှတ်စု";

  @override
  String get notificationSetting => "နိုတီဖီကေးရှင်း ပြင်ဆင်ခန်း";

  @override
  String get overlay => "Overlay ပြင်ဆင်ခန်း";

  @override
  String get sound => "အသံ ပြင်ဆင်ခန်း";

  @override
  String get textBrigthness => "စာသား အရောင်";

  @override
  String get themes => "အလှဆင်ခြင်း";

  @override
  String get todo => "လုပ်ဆောင်ရန်";

  @override
  String get notiMoveToNextDay =>
      "အသိပေးချက်ကို မနက်ဖြန်သို့ ‌‌‌‌ပြောင်း‌‌ရွေ့သတ်မှတ်လိုက်ပါပြီ";
}

class EnglishLanguage extends BaseLanguage {
  @override
  String get settings => "Setting";

  @override
  String get language => "Language";

  @override
  String get palette => "Palette";

  @override
  String get textScale => "Text Scale";

  @override
  String get notification => "Notification";

  @override
  String get addingNote => "Adding Note";

  @override
  String get addingTask => "Adding Task";

  @override
  String get taskName => "Task Name";

  @override
  String get add => "Add";

  @override
  String get canEditLater => "Can Edit Later";

  @override
  String get caption => "Caption";

  @override
  String get chooseColor => "Choose Color";

  @override
  String get keepYourNoteHere => "Keep Your Note Here";

  @override
  String get noKeepNote => "No Keep Note";

  @override
  String get addingGroupTask => "Adding Group Task";

  @override
  String get groupName => "Group Name";

  @override
  String get noTask => "No Tasks";

  @override
  String get taskDescription => "Task Description";

  @override
  String get edit => "Edit";

  @override
  String get keepNote => "Keep Notes";

  @override
  String get advancedOption => "Advanced Options";

  @override
  String get attachedNotes => "Attached Notes";

  @override
  String get editTask => "Edit Task";

  @override
  String get remainder => "Remainder";

  @override
  String get successfullyEdited => "Successfully Edited";

  @override
  String get completed => "Completed";

  @override
  String get areYourSureToDelete => "Are you sure to delete ";

  @override
  String get confirm => "Confirm";

  @override
  String get heyBuddy => "Great Task To Done";

  @override
  String get setRemainder => "Set Remainder";

  @override
  String get archieve => "Archieve";

  @override
  String get close => "Close";

  @override
  String get dueTime => "Due Time";

  @override
  String get favourite => "Favourite";

  @override
  String get notiBody => "Body";

  @override
  String get notiTitle => "Title";

  @override
  String get pravicy => "Pravicy Policy";

  @override
  String get premium => "Premium";

  @override
  String get rateUs => "Rate Us";

  @override
  String get setAlarm => "Set Alarm";

  @override
  String get share => "Share";

  @override
  String get sharePhoto => "Share Photo";

  @override
  String get shareText => "Share Text";

  @override
  String get terms => "Terms Of Services";

  @override
  String get unArchieve => "Unarchieve";

  @override
  String get archieves => "Archieve";

  @override
  String get captionIsRequired => "Caption is required";

  @override
  String get favourites => "Favourites";

  @override
  String get groupNameIsRequred => "Group name is required";

  @override
  String get notiBodyIsRequried => "Notification Title is required";

  @override
  String get notiTitleIsRequired => "Notification Body is required";

  @override
  String get taskNameIsRequired => "Task Name is required";

  @override
  String get noArchieves => "No Archieve";

  @override
  String get noFavourites => "No Favourite";

  @override
  String get activated => "Activated";

  @override
  String get addImage => "Add Image";

  @override
  String get floppyNote => "Floppy Note";

  @override
  String get notificationSetting => "Notification Setting";

  @override
  String get overlay => "Overlay Setting";

  @override
  String get sound => "Sound Setting";

  @override
  String get textBrigthness => "Text Brightness";

  @override
  String get themes => "Themes";

  @override
  String get todo => "To Do";

  @override
  String get notiMoveToNextDay => "Added to next day";
}
