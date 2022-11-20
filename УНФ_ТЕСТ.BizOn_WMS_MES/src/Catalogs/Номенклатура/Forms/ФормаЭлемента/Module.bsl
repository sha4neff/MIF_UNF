&После("ПриСозданииНаСервере")
Процедура БЗ_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	МестоВставки = Элементы["ИзображениеАктуальныеЦены"];
//СтраницыФормы = Элементы.
	//	"СтраницыФормы",
	//	Тип("ГруппаФормы"),
	//	ЭтаФорма);
	//	
	//СтраницыФормы.Вид = ВидГруппыФормы.Страницы;
	//
	////Подключить обработчик при смене страницы
	//СтраницыФормы.УстановитьДействие("ПриСменеСтраницы", "ДействиеПриСменеСтраницы");
	//
	////Добавление 1-й страницы
	//СтраницаФормы1 = Элементы.Добавить(
	//	"Страница1",
	//	Тип("ГруппаФормы"),
	//	СтраницыФормы);
	//	
	//СтраницаФормы1.Вид = ВидГруппыФормы.Страница;
	//СтраницаФормы1.Заголовок = "Первая страница";
	//
	ПолеВвода = Элементы.Добавить(
		"БЗ_WMS_Дата",    //Имя элемента формы
		Тип("ПолеФормы"), //Тип, всегда ПолеФормы
		МестоВставки);	      //Контейнер для поля ввода (Форма,Группа,Страница)
		
	ПолеВвода.Заголовок = "WMS дата начала учета";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	
	//Установка связи элемента с данными
	ПолеВвода.ПутьКДанным = "Объект.БЗ_WMS_Дата";	
	ПолеВвода = Элементы.Добавить(
		"БЗ_MES_Дата",    //Имя элемента формы
		Тип("ПолеФормы"), //Тип, всегда ПолеФормы
		МестоВставки);	      //Контейнер для поля ввода (Форма,Группа,Страница)
		
	ПолеВвода.Заголовок = "MES дата начала учета";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	
	//Установка связи элемента с данными
	ПолеВвода.ПутьКДанным = "Объект.БЗ_MES_Дата";
	
	ПолеВвода = Элементы.Добавить(
		"БЗ_РазрешитьВводБезШК",    //Имя элемента формы
		Тип("ПолеФормы"), //Тип, всегда ПолеФормы
		МестоВставки);	      //Контейнер для поля ввода (Форма,Группа,Страница)
		
	ПолеВвода.Заголовок = "Разрешить отгрузку без ШК";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	
	//Установка связи элемента с данными
	ПолеВвода.ПутьКДанным = "Объект.БЗ_РазрешитьВводБезШК";

КонецПроцедуры