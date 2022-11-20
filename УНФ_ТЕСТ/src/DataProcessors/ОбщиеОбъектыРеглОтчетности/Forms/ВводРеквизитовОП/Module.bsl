
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбрабатываемыеДанные= Новый Структура;
	
	ОбрабатываемыеДанные.Вставить("Наименование", "");
	ОбрабатываемыеДанные.Вставить("ИНН",          "");
	ОбрабатываемыеДанные.Вставить("КПП",          "");
	
	ОбрабатываемыеДанные.Вставить("Страна",          "РОССИЯ");
	ОбрабатываемыеДанные.Вставить("Индекс",          "");
	ОбрабатываемыеДанные.Вставить("Регион",          "");
	ОбрабатываемыеДанные.Вставить("КодРегиона",      "");
	ОбрабатываемыеДанные.Вставить("Район",           "");
	ОбрабатываемыеДанные.Вставить("Город",           "");
	ОбрабатываемыеДанные.Вставить("НаселенныйПункт", "");
	ОбрабатываемыеДанные.Вставить("Улица",           "");
	ОбрабатываемыеДанные.Вставить("Дом",             "");
	ОбрабатываемыеДанные.Вставить("Корпус",          "");
	ОбрабатываемыеДанные.Вставить("Квартира",        "");
	ОбрабатываемыеДанные.Вставить("ТипДома",         "");
	ОбрабатываемыеДанные.Вставить("ТипКорпуса",      "");
	ОбрабатываемыеДанные.Вставить("ТипКвартиры",     "");
	
	ОбрабатываемыеДанные.Вставить("ПредставлениеАдреса", "");
	
	Если ТипЗнч(Параметры.СведенияОбОП) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ОбрабатываемыеДанные, Параметры.СведенияОбОП);
		ОбрабатываемыеДанные.Вставить("Регион", РегламентированнаяОтчетностьВызовСервера.ПолучитьНазваниеРегионаПоКоду(Параметры.СведенияОбОП.КодРегиона));
	КонецЕсли;

	Наименование = ОбрабатываемыеДанные.Наименование;
	ИНН = ОбрабатываемыеДанные.ИНН;
	КПП = ОбрабатываемыеДанные.КПП;
	
	СправочникиВидыКонтактнойИнформацииФактАдресОрганизации = Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации;
	
	ВывестиПредставлениеАдреса(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВывестиПредставлениеАдреса(Форма)
	
	Если НЕ ПустаяСтрока(Форма.ОбрабатываемыеДанные.ПредставлениеАдреса) Тогда
		Форма.Элементы.АдресОП.Заголовок = Форма.ОбрабатываемыеДанные.ПредставлениеАдреса;
	Иначе
		Форма.Элементы.АдресОП.Заголовок = НСтр("ru='Ввести адрес обособленного подразделения'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОПНажатие(Элемент)
	
	ЗначенияПолей = Новый СписокЗначений;

	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Страна,          "Страна");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Индекс,          "Индекс");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.КодРегиона,      "КодРегиона");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Регион,          "Регион");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Район,           "Район");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Город,           "Город");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.НаселенныйПункт, "НаселенныйПункт");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Улица,           "Улица");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Дом,             "Дом");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Корпус,          "Корпус");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.Квартира,        "Квартира");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.ТипДома,         "ТипДома");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.ТипКорпуса,      "ТипКорпуса");
	ЗначенияПолей.Добавить(ОбрабатываемыеДанные.ТипКвартиры,     "ТипКвартиры");

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",               "Ввод адреса");
	ПараметрыФормы.Вставить("ЗначенияПолей", 		   ЗначенияПолей);
	ПараметрыФормы.Вставить("Представление", 		   ОбрабатываемыеДанные.ПредставлениеАдреса);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформации", СправочникиВидыКонтактнойИнформацииФактАдресОрганизации);
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(2);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтаФорма;
	
	Оповещение = Новый (ТипЗначения, ПараметрыКонструктора);
	
	ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, Параметры) Экспорт
	
	ОбновитьАдресВТабличномДокументе(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресВТабличномДокументе(Результат)
	
	Если Результат <> Неопределено Тогда
		
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			
			Адрес = Новый Структура;
			
			Адрес.Вставить("Страна",          "РОССИЯ");
			Адрес.Вставить("Индекс", 		  "");
			Адрес.Вставить("Регион",          "");
			Адрес.Вставить("КодРегиона",      "");
			Адрес.Вставить("Район",           "");
			Адрес.Вставить("Город",           "");
			Адрес.Вставить("НаселенныйПункт", "");
			Адрес.Вставить("Улица",           "");
			Адрес.Вставить("Дом",             "");
			Адрес.Вставить("Корпус",          "");
			Адрес.Вставить("Квартира",        "");
			Адрес.Вставить("ТипДома",         "");
			Адрес.Вставить("ТипКорпуса",      "");
			Адрес.Вставить("ТипКвартиры",     "");
			
			РегламентированнаяОтчетностьВызовСервера.СформироватьАдрес(Результат.КонтактнаяИнформация, Адрес);
			
			ЗаполнитьЗначенияСвойств(ОбрабатываемыеДанные, Адрес);
			ОбрабатываемыеДанные.ПредставлениеАдреса = Результат.Представление;
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ВывестиПредставлениеАдреса(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ЭтаФорма.Закрыть(РезультатВвода());

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЭтаФорма.Закрыть();

КонецПроцедуры

&НаКлиенте
Функция РезультатВвода()
	
	ОбрабатываемыеДанные.Наименование = Наименование;
	ОбрабатываемыеДанные.ИНН = ИНН;
	ОбрабатываемыеДанные.КПП = КПП;
	
	ОбрабатываемыеДанные.Удалить("Регион");

	Возврат ОбрабатываемыеДанные;
	
КонецФункции

#КонецОбласти