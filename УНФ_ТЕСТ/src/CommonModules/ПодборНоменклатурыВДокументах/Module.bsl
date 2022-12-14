
#Область СлужебныйПрограммныйИнтерфейс

// Функция - Возвращает имя формы подбора по документу
//
// Параметры:
//  ПолноеИмяДокумента	 - Строка	 - Имя документа
//  ИмяТабличнойЧасти	 - Строка	 - Имя табличной части, для которой открывается подбор
// 
// Возвращаемое значение:
// 	Строка - Имя формы подбора
//
Функция ИмяФормыПодбораПоДокументу(ПолноеИмяДокумента, ИмяТабличнойЧасти) Экспорт
	Перем ИмяФормыПодбора, ТаблицаИспользования;
	
	СоздатьШаблонТаблицыИспользования(ТаблицаИспользования);
	ПодборНоменклатурыВДокументахПереопределяемый.ТаблицаИспользованияФормПодбора(ТаблицаИспользования);
	
	ОтборСтрок = Новый Структура("ИмяДокумента, ИмяТабличнойЧасти", ПолноеИмяДокумента, ИмяТабличнойЧасти);
	НайденныеСтроки = ТаблицаИспользования.НайтиСтроки(ОтборСтрок);
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Не удалось определить какую форму подбора использовать.'");
		ЗаписьЖурналаРегистрации("ПодборНоменклатуры", УровеньЖурналаРегистрации.Информация, , , ТекстСообщения, РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
		
		Возврат ""; // если ошибка определения формы, открыть старую форму подбора.
		
	КонецЕсли;
	
	Возврат НайденныеСтроки[0].ФормаПодбора;
	
КонецФункции

// Процедура - Назначить форму подбора
//
// Параметры:
//  ПараметрыОткрытияПодбора - Структура - Реквизит формы, хранящий настройки подбора
//  ПолноеИмяДокумента		 - Строка	 - Имя документа
//  ИмяТабличнойЧасти		 - Строка	 - Имя табличной части, для которой открывается подбор
//
Процедура НазначитьФормуПодбора(ПараметрыОткрытияПодбора, ПолноеИмяДокумента, ИмяТабличнойЧасти) Экспорт
	
	Если ТипЗнч(ПараметрыОткрытияПодбора) <> Тип("Структура") Тогда
		
		ПараметрыОткрытияПодбора = Новый Структура;
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ЗначениеНастройкиПользователя = Истина;
		
	Иначе
		
		ЗначениеНастройкиПользователя = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ИспользоватьНовыйМеханизмПодбора");
		
	КонецЕсли;
	
	Если ЗначениеНастройкиПользователя Тогда
		
		ИмяФормыПодбора = ИмяФормыПодбораПоДокументу(ПолноеИмяДокумента, ИмяТабличнойЧасти);
		ПараметрыОткрытияПодбора.Вставить(ИмяТабличнойЧасти, ИмяФормыПодбора);
		
	Иначе
		
		ПараметрыОткрытияПодбора.Вставить(ИмяТабличнойЧасти, "");
		
	КонецЕсли;
	
КонецПроцедуры

// Получает цену и единицу измерения номенклатуры по указанному виду цен
//
// Возвращаемое значение:
//  Структура:
//		- Цена (Число). Полученная цена номенклатуры по прайсу.
//		- ЕдиницаИзмерения (Справочник ЕдиницыИзмерения или КлассификаторЕдиницИзмерения). Единица измерения указанная в цене.
//
Функция ПолучитьЦенуИЕдиницуИзмеренияНоменклатурыПоВидуЦен(СтруктураДанных) Экспорт
	
	ВидЦенПараметр = СтруктураДанных.ВидЦен;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЦеныНоменклатурыСрезПоследних.ВидЦен.ВалютаЦены КАК ЦеныНоменклатурыВалюта,
	|	ЦеныНоменклатурыСрезПоследних.ВидЦен.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ЦеныНоменклатурыСрезПоследних.ВидЦен.ПорядокОкругления КАК ПорядокОкругления,
	|	ЦеныНоменклатурыСрезПоследних.ВидЦен.ОкруглятьВБольшуюСторону КАК ОкруглятьВБольшуюСторону,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена * КурсВалютыВидЦен.Курс * КурсВалютыДокумента.Кратность / (КурсВалютыДокумента.Курс * КурсВалютыВидЦен.Кратность) * ЕСТЬNULL(&Коэффициент, 1) / ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.ЕдиницаИзмерения.Коэффициент, 1), 0) КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			&ДатаОбработки,
	|			Номенклатура = &Номенклатура
	|				И Характеристика = &Характеристика
	|				И ВидЦен = &ВидЦен) КАК ЦеныНоменклатурыСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОбработки, ) КАК КурсВалютыВидЦен
	|		ПО ЦеныНоменклатурыСрезПоследних.ВидЦен.ВалютаЦены = КурсВалютыВидЦен.Валюта,
	|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОбработки, Валюта = &ВалютаДокумента) КАК КурсВалютыДокумента
	|ГДЕ
	|	ЦеныНоменклатурыСрезПоследних.Актуальность";
	
	Запрос.УстановитьПараметр("ДатаОбработки",	 СтруктураДанных.ДатаОбработки);
	Запрос.УстановитьПараметр("Номенклатура",	 СтруктураДанных.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика",  СтруктураДанных.Характеристика);
	Запрос.УстановитьПараметр("Коэффициент",	 СтруктураДанных.Коэффициент);
	Запрос.УстановитьПараметр("ВалютаДокумента", СтруктураДанных.ВалютаДокумента);
	Запрос.УстановитьПараметр("ВидЦен",			 ВидЦенПараметр);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Цена			= 0;
	ЕдиницаИзмерения= Неопределено;
	Пока Выборка.Следующий() Цикл
		
		Цена						= Выборка.Цена;
		ЕдиницаИзмерения			= Выборка.ЕдиницаИзмерения;
		ПорядокОкругления			= Выборка.ПорядокОкругления;
		ОкруглятьВБольшуюСторону	= Выборка.ОкруглятьВБольшуюСторону;
		
		Если СтруктураДанных.Свойство("СуммаВключаетНДС")
			И (СтруктураДанных.СуммаВключаетНДС <> Выборка.ЦенаВключаетНДС) Тогда
			
			Цена = УправлениеНебольшойФирмойСервер.ПересчитатьСуммуПриИзмененииФлаговНДС(Цена, СтруктураДанных.СуммаВключаетНДС, СтруктураДанных.СтавкаНДС);
			
		КонецЕсли;
		
		Цена = УправлениеНебольшойФирмойСервер.ОкруглитьЦену(Цена, ПорядокОкругления, ОкруглятьВБольшуюСторону);
		
	КонецЦикла;
	
	Возврат Новый Структура("ЕдиницаИзмерения, Цена", ЕдиницаИзмерения, Цена);
	
КонецФункции // ПолучитьЦенуИЕдиницуИзмеренияНоменклатурыПоВидуЦен()

// Получает цену и единицу измерения номенклатуры по указанному виду цен
//
// Возвращаемое значение:
//  Структура:
//		- Цена (Число). Полученная цена номенклатуры по прайсу.
//		- ЕдиницаИзмерения (Справочник ЕдиницыИзмерения или КлассификаторЕдиницИзмерения). Единица измерения указанная в цене.
//
Функция ПолучитьЦенуИЕдиницуИзмеренияНоменклатурыПоВидуЦенКонтрагента(СтруктураДанных) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыКонтрагентовСрезПоследних.ВидЦенКонтрагента.ВалютаЦены КАК ЦеныНоменклатурыВалюта,
	|	ЦеныНоменклатурыКонтрагентовСрезПоследних.ВидЦенКонтрагента.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ЦеныНоменклатурыКонтрагентовСрезПоследних.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЕСТЬNULL(ЦеныНоменклатурыКонтрагентовСрезПоследних.Цена * КурсВалютыВидЦен.Курс * КурсВалютыДокумента.Кратность / (КурсВалютыДокумента.Курс * КурсВалютыВидЦен.Кратность) * ЕСТЬNULL(&Коэффициент, 1) / ЕСТЬNULL(ЦеныНоменклатурыКонтрагентовСрезПоследних.ЕдиницаИзмерения.Коэффициент, 1), 0) КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних(
	|			&ДатаОбработки,
	|			Номенклатура = &Номенклатура
	|				И Характеристика = &Характеристика
	|				И ВидЦенКонтрагента = &ВидЦенКонтрагента) КАК ЦеныНоменклатурыКонтрагентовСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОбработки, ) КАК КурсВалютыВидЦен
	|		ПО ЦеныНоменклатурыКонтрагентовСрезПоследних.ВидЦенКонтрагента.ВалютаЦены = КурсВалютыВидЦен.Валюта,
	|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОбработки, Валюта = &ВалютаДокумента) КАК КурсВалютыДокумента
	|ГДЕ
	|	ЦеныНоменклатурыКонтрагентовСрезПоследних.Актуальность";
	
	Запрос.УстановитьПараметр("ДатаОбработки",		СтруктураДанных.ДатаОбработки);
	Запрос.УстановитьПараметр("Номенклатура",		СтруктураДанных.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика",		СтруктураДанных.Характеристика);
	Запрос.УстановитьПараметр("Коэффициент",		СтруктураДанных.Коэффициент);
	Запрос.УстановитьПараметр("ВалютаДокумента",	СтруктураДанных.ВалютаДокумента);
	Запрос.УстановитьПараметр("ВидЦенКонтрагента",	СтруктураДанных.ВидЦенКонтрагента);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Цена			= 0;
	ЕдиницаИзмерения= Неопределено;
	Пока Выборка.Следующий() Цикл
		
		Цена			= Выборка.Цена;
		ЕдиницаИзмерения= Выборка.ЕдиницаИзмерения;
		
		Если СтруктураДанных.СуммаВключаетНДС <> Выборка.ЦенаВключаетНДС Тогда
			
			Цена = УправлениеНебольшойФирмойСервер.ПересчитатьСуммуПриИзмененииФлаговНДС(Цена, СтруктураДанных.СуммаВключаетНДС, СтруктураДанных.СтавкаНДС);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый Структура("ЕдиницаИзмерения, Цена", ЕдиницаИзмерения, Цена);
	
КонецФункции // ПолучитьЦенуИЕдиницуИзмеренияНоменклатурыПоВидуЦенКонтрагента()

// Процедура позволяет выполнить начальное заполнение пользовательских настроек
//
Процедура НачальноеЗаполнениеНастроекПодбора(Пользователь = Неопределено, СтандартнаяОбработка = Истина) Экспорт
	
	ПодборНоменклатурыВДокументахПереопределяемый.ПереопределитьНачальноеЗаполнениеНастроекПодбора(Пользователь, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка = Истина Тогда
		
		УправлениеНебольшойФирмойСервер.УстановитьНастройкуПользователя(Истина, "ИспользоватьНовыйМеханизмПодбора", Пользователь);
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПользовательскиеНастройки()

// Процедура устанавливает параметры выбора по переданной структуре/массиву с типами номенклатур
//
Процедура УстановитьПараметрыВыбораНоменклатуры(Элемент, Знач ТипНоменклатуры) Экспорт
	
	Если ЭтоСписокЗначений(ТипНоменклатуры) Тогда
		
		ТипНоменклатуры = СписокЗначенийВМассив(ТипНоменклатуры);
		
	КонецЕсли;
	
	Если ТипЗнч(Элемент) <> Тип("ПолеФормы")
		ИЛИ ТипЗнч(ТипНоменклатуры) <> Тип("Массив")
		ИЛИ ТипНоменклатуры.Количество() < 1 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипНоменклатуры", Новый ФиксированныйМассив(ТипНоменклатуры));
	
	МассивПараметровВыбора = Новый Массив;
	МассивПараметровВыбора.Добавить(НовыйПараметр);
	Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
	
	
КонецПроцедуры // УстановитьСвязиПараметровВыбора()

// Процедура устанавливает параметры выбора по переданной структуре/массиву с типами номенклатур
//
Процедура УстановитьПараметрыВыбораПартий(Элемент, Знач ВидОперации) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВидОперации) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если НЕ ТипЗнч(Элемент) = Тип("ПолеФормы") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ОдинКОдному = Новый Соответствие;
	ОдинКОдному.Вставить(Перечисления.ВидыОперацийРасходнаяНакладная.ВозвратКомитенту,			Перечисления.СтатусыПартий.ТоварыНаКомиссии);
	ОдинКОдному.Вставить(Перечисления.ВидыОперацийРасходнаяНакладная.ВозвратИзПереработки,		Перечисления.СтатусыПартий.ДавальческоеСырье);
	ОдинКОдному.Вставить(Перечисления.ВидыОперацийРасходнаяНакладная.ВозвратСОтветхранения,		Перечисления.СтатусыПартий.ОтветственноеХранение);
	ОдинКОдному.Вставить(Перечисления.ВидыОперацийПриходнаяНакладная.ПриемНаКомиссию,			Перечисления.СтатусыПартий.ТоварыНаКомиссии);
	ОдинКОдному.Вставить(Перечисления.ВидыОперацийПриходнаяНакладная.ПриемВПереработку,			Перечисления.СтатусыПартий.ДавальческоеСырье);
	ОдинКОдному.Вставить(Перечисления.ВидыОперацийПриходнаяНакладная.ПриемНаОтветхранение,		Перечисления.СтатусыПартий.ОтветственноеХранение);
	
	ЗначениеОтбораСтатусаПартии = ОдинКОдному[ВидОперации];
	Если ЗначениеОтбораСтатусаПартии <> Неопределено Тогда
		
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Статус", ЗначениеОтбораСтатусаПартии);
		
		НовыйМассив = Новый Массив;
		НовыйМассив.Добавить(НовыйПараметр);
		
		Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассив);
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРасходнаяНакладная.ПродажаПокупателю
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя Тогда
		
		НовыйМассив = Новый Массив;
		НовыйМассив.Добавить(Перечисления.СтатусыПартий.СобственныеЗапасы);
		НовыйМассив.Добавить(Перечисления.СтатусыПартий.ТоварыНаКомиссии);
		
		МассивСобственныеЗапасыИТоварыНаКомиссии = Новый ФиксированныйМассив(НовыйМассив);
		
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Статус", МассивСобственныеЗапасыИТоварыНаКомиссии);
		НовыйПараметр2 = Новый ПараметрВыбора("Дополнительно.ОграничениеСтатуса", МассивСобственныеЗапасыИТоварыНаКомиссии);
		
		НовыйМассив = Новый Массив;
		НовыйМассив.Добавить(НовыйПараметр);
		НовыйМассив.Добавить(НовыйПараметр2);
		
		Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассив);
		
	Иначе
		
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Статус", Перечисления.СтатусыПартий.СобственныеЗапасы);
		
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(НовыйПараметр);
		
		Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассив);
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьСвязиПараметровВыбора()

// Процедура управляет видимостью наборов/комплектов в списке запасов
//
Процедура ВидимостьНаборовКомплектов(ТабличныеЧасти, КешНастройкиПодбора) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНаборы") Тогда
		
		Для каждого СписокФормы Из ТабличныеЧасти Цикл
			
			ОтборыДинамическогоСписка = СписокФормы.КомпоновщикНастроек.Настройки.Отбор.Элементы;
			Для каждого ЭлементОтбора Из ОтборыДинамическогоСписка Цикл
				
				Если ЭлементОтбора.Представление = "НаборыКомплекты" Тогда
					
					ЭлементОтбора.Использование = НЕ КешНастройкиПодбора.СведенияОДокументе.ПоказыватьНаборыКомплекты;
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ВидимостьНаборовКомплектов()

#Область ПреобразованиеТипов

// Преобразует набор данных с типом СписокЗначений в Массив
// 
Функция СписокЗначенийВМассив(ВхСписокЗначений) Экспорт
	
	МассивДанных = Новый Массив;
	
	Для каждого ЭлементСпискаЗначений Из ВхСписокЗначений Цикл
		
		МассивДанных.Добавить(ЭлементСпискаЗначений.Значение);
		
	КонецЦикла;
	
	Возврат МассивДанных;
	
КонецФункции // СписокЗначенийВМассив()

// Функция опредяет имеет ли тип СписокЗначений полученная переменная
//
Функция ЭтоСписокЗначений(ВходящиеЗначение) Экспорт
	
	Возврат (ТипЗнч(ВходящиеЗначение) = Тип("СписокЗначений"));
	
КонецФункции // ЭтоСписокЗначений()

#КонецОбласти 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура создает пустую таблицу-шаблон использования форм подбора по документам
//
Процедура СоздатьШаблонТаблицыИспользования(ТаблицаИспользования)
	
	ДопустимыеТипы = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(100));
	
	ТаблицаИспользования = Новый ТаблицаЗначений;
	ТаблицаИспользования.Колонки.Добавить("ИмяДокумента",		ДопустимыеТипы);
	ТаблицаИспользования.Колонки.Добавить("ИмяТабличнойЧасти",	ДопустимыеТипы);
	ТаблицаИспользования.Колонки.Добавить("ФормаПодбора", 		ДопустимыеТипы);
	
КонецПроцедуры // СоздатьШаблонТаблицыИспользования()

#КонецОбласти 


 

