class MenuCard {
  String image;
  String menu;
  String calories;

  MenuCard(this.image, this.menu, this.calories);

  List<MenuCard> getMenuCard() {
    //query menu image, menu name, calories
    return [
      MenuCard(
          "https://www.haveazeed.com/wp-content/uploads/2019/08/3.%E0%B8%AA%E0%B9%89%E0%B8%A1%E0%B8%95%E0%B8%B3%E0%B9%84%E0%B8%97%E0%B8%A2%E0%B9%84%E0%B8%82%E0%B9%88%E0%B9%80%E0%B8%84%E0%B9%87%E0%B8%A1-1.png",
          "ตำไทยไข่เค็ม",
          "172"),
      MenuCard("https://dilafashionshop.files.wordpress.com/2019/03/71.jpg",
          "ข้าวกะเพราไก่ไข่ดาว", "480"),
      MenuCard(
          "https://img.kapook.com/u/pirawan/Cooking1/thai%20spicy%20mushrooms%20salad.jpg",
          "ยำเห็ดรวมมิตร",
          "104"),
      MenuCard(
          "https://snpfood.com/wp-content/uploads/2020/01/Breakfast-00002-scaled-1-1536x1536.jpg",
          "ข้าวต้มปลา",
          "220"),
      MenuCard(
          "https://snpfood.com/wp-content/uploads/2020/01/Highlight-Menu-0059-scaled-1-1536x1536.jpg",
          "ข้าวผัดปู",
          "551"),
    ]; //dummy data
  }
}