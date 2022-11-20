#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

// Получает реквизиты объекта, которые необходимо блокировать от изменения
//
// Параметры:
//  Нет
//
// Возвращаемое значение:
//  Массив - блокируемые реквизиты объекта
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("ТипПодключаемогоОборудования");
	
	Возврат Результат;

КонецФункции

Функция СписокТоваровПоПравилу(ПравилоОбмена) Экспорт
	
	СтруктураРеквизитовПравила = Новый Структура;
	СтруктураРеквизитовПравила.Вставить("СтруктурнаяЕдиница", "СтруктурнаяЕдиница");
	СтруктураРеквизитовПравила.Вставить("ВыгружатьГруппыТоваров", "ВыгружатьГруппыТоваров");
	СтруктураРеквизитовПравила.Вставить("НастройкиКомпоновкиДанных", "НастройкиКомпоновкиДанных");
	СтруктураРеквизитовПравила.Вставить("ТипПодключаемогоОборудования", "ТипПодключаемогоОборудования"); 
	СтруктураРеквизитовПравила.Вставить("Организация", "СтруктурнаяЕдиница.Организация");
	СтруктураРеквизитовПравила.Вставить("ВидЦеныНоменклатуры", "ВидЦеныНоменклатуры");
	
	РеквизитыПравила = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПравилоОбмена, СтруктураРеквизитовПравила);
	СтруктурнаяЕдиница = РеквизитыПравила.СтруктурнаяЕдиница;
//	Магазин = РеквизитыПравила.Организация;
	ВидЦеныНоменклатуры = РеквизитыПравила.ВидЦеныНоменклатуры;
	
	СхемаКомпоновкиДанных = Справочники.ПравилаОбменаСПодключаемымОборудованиемOffline.ПолучитьМакет("ОбновлениеКодовSKU");
	
	// Подготовка компоновщика макета компоновки данных, загрузка настроек.
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	Компоновщик.ЗагрузитьНастройки(РеквизитыПравила.НастройкиКомпоновкиДанных.Получить());
	Компоновщик.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	// Заполнение структуры отчета и выбранных полей.
	Компоновщик.Настройки.Структура.Очистить();
	
	ГруппировкаДетальныеЗаписи = Компоновщик.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаДетальныеЗаписи.Использование = Истина;
	
	Компоновщик.Настройки.Выбор.Элементы.Очистить();
	
	ВыбранноеПоле               = ГруппировкаДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных("Номенклатура");
	ВыбранноеПоле.Использование = Истина;
	
	ВыбранноеПоле               = ГруппировкаДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных("Группа");
	ВыбранноеПоле.Использование = Истина;
	
	ВыбранноеПоле               = ГруппировкаДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных("ЕдиницаИзмерения");
	ВыбранноеПоле.Использование = Истина;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
		ВыбранноеПоле               = ГруппировкаДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных("Характеристика");
		ВыбранноеПоле.Использование = Истина;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартии") Тогда
		ВыбранноеПоле               = ГруппировкаДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных("Партия");
		ВыбранноеПоле.Использование = Истина;
	КонецЕсли;
	
	ВыбранноеПоле               = ГруппировкаДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных("SKU");
	ВыбранноеПоле.Использование = Истина;
	
	ВыбранноеПоле               = ГруппировкаДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных("Весовой");
	ВыбранноеПоле.Использование = Истина;
	
	ВыбранноеПоле               = ГруппировкаДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных("ЭтоГруппа");
	ВыбранноеПоле.Использование = Истина;
	
	
	ВыбранноеПоле               = ГруппировкаДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных("КоличествоОстаток");
	ВыбранноеПоле.Использование = Истина;
	
	ВыбранноеПоле               = ГруппировкаДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных("Цена");
	ВыбранноеПоле.Использование = Истина;
	
	// Компоновка макета и исполнение запроса.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Попытка
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Компоновщик.ПолучитьНастройки(), , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	Исключение
		
		ТекстСообщения = НСтр("ru='В процессе формирования списка товаров произошла ошибка.
								|Правило обмена с подключаемым оборудованием %1 требует проверки.
								|%2'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ПравилоОбмена, ОписаниеОшибки());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат Неопределено;
		
	КонецПопытки;
	
	Параметр = МакетКомпоновки.ЗначенияПараметров.Найти("Дата");
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Параметр = МакетКомпоновки.ЗначенияПараметров.Найти("ПравилоОбмена");
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = ПравилоОбмена;
	КонецЕсли;
	
	Параметр = МакетКомпоновки.ЗначенияПараметров.Найти("Склад");
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = СтруктурнаяЕдиница;
	КонецЕсли;
	
	Параметр = МакетКомпоновки.ЗначенияПараметров.Найти("ВидЦеныНоменклатуры");
	Если Параметр <> Неопределено Тогда
		Если ЗначениеЗаполнено(ВидЦеныНоменклатуры) Тогда
			Параметр.Значение = ВидЦеныНоменклатуры;
		Иначе
			Параметр.Значение = Справочники.ВидыЦен.ПолучитьОсновнойВидЦенПродажи();
		КонецЕсли;
	КонецЕсли;
	
	Параметр = МакетКомпоновки.ЗначенияПараметров.Найти("ТолькоСУстановленнымиЦенами");
	ТолькоСУстановленнымиЦенами = Ложь;
	
	Если Параметр <> Неопределено Тогда
		
		ТолькоСЦенами = Новый ПолеКомпоновкиДанных("ТолькоСУстановленнымиЦенами");
		
		СписокЭлементовОтбора = Компоновщик.Настройки.Отбор.Элементы;
		
		Для каждого Элемент Из СписокЭлементовОтбора Цикл
			Если Элемент.ЛевоеЗначение = ТолькоСЦенами И Элемент.Использование Тогда
				ТолькоСУстановленнымиЦенами = Элемент.ПравоеЗначение;
			КонецЕсли;
		КонецЦикла;
		
		Параметр.Значение = ТолькоСУстановленнымиЦенами;
		
	КонецЕсли;
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ДанныеОтчета = Новый ТаблицаЗначений();
	ПроцессорВывода.УстановитьОбъект(ДанныеОтчета);
	ДанныеОтчета = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
		ДанныеОтчета.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПартии") Тогда
		ДанныеОтчета.Колонки.Добавить("Партия", Новый ОписаниеТипов("СправочникСсылка.ПартииНоменклатуры"));
	КонецЕсли;

	Если НЕ ПолучитьФункциональнуюОпцию("УчетВРазличныхЕдиницахИзмерения") Тогда
		ДанныеОтчета.Колонки.Добавить("ЕдиницаИзмерения", Новый ОписаниеТипов("СправочникСсылка.ЕдиницыИзмерения"));
	КонецЕсли;
	
	//ДанныеОтчета.Колонки.Добавить("ЕдиницаХранения", Новый ОписаниеТипов("СправочникСсылка.КлассификаторЕдиницИзмерения"));
	
	Если РеквизитыПравила.ВыгружатьГруппыТоваров Тогда
		МассивНоменклатур = ДанныеОтчета.ВыгрузитьКолонку("Номенклатура");
		ДобавитьГруппыНоменклатуры(ДанныеОтчета, МассивНоменклатур);
		ДанныеОтчета.Свернуть("SKU, Весовой, Группа, КоличествоОстаток, Номенклатура, Характеристика, Партия, ЕдиницаИзмерения, ЭтоГруппа, Цена");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Партия КАК Партия,
	|	Товары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Товары.Группа КАК Группа,
	|	Товары.ЭтоГруппа КАК ЭтоГруппа,
	|	Товары.SKU КАК SKU,
	|	Товары.Весовой КАК Весовой,
	|	Товары.КоличествоОстаток КАК КоличествоОстаток,
	|	Товары.Цена
	|ПОМЕСТИТЬ ТаблицаДанныхСОтбором
	|ИЗ
	|	&Товары КАК Товары
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ТолькоСУстановленнымиЦенами
	|				ТОГДА НЕ(Товары.Цена = 0
	|							И НЕ Товары.ЭтоГруппа)
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
		
	|ИНДЕКСИРОВАТЬ ПО
	|	SKU
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КодыТоваровPLUНаОборудовании.КодТовараSKU,
	|	КодыТоваровPLUНаОборудовании.КодТовараPLU
	|ПОМЕСТИТЬ ТаблицаКодыТоваров
	|ИЗ
	|	РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
	|ГДЕ
	|	КодыТоваровPLUНаОборудовании.ПравилоОбмена = &ПравилоОбмена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДанныхСОтбором.SKU КАК SKU,
	|	ТаблицаКодыТоваров.КодТовараPLU КАК PLU,
	|	ТаблицаДанныхСОтбором.Номенклатура,
	|	ТаблицаДанныхСОтбором.Характеристика,
	|	ТаблицаДанныхСОтбором.Партия,
	|	ТаблицаДанныхСОтбором.ЕдиницаИзмерения,
	|	ТаблицаДанныхСОтбором.Группа КАК Группа,
	|	ТаблицаДанныхСОтбором.ЭтоГруппа КАК ЭтоГруппа,
	|	ТаблицаДанныхСОтбором.Цена КАК Цена,
	|	ТаблицаДанныхСОтбором.Весовой КАК Весовой,
	|	ТаблицаДанныхСОтбором.КоличествоОстаток КАК КоличествоОстаток,
	|	ВЫБОР
	|		КОГДА ТаблицаДанныхСОтбором.ЭтоГруппа
	|			ТОГДА 0
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК ИндексПиктограммы
	|ИЗ
	|	ТаблицаКодыТоваров КАК ТаблицаКодыТоваров
	|		ПОЛНОЕ СОЕДИНЕНИЕ ТаблицаДанныхСОтбором КАК ТаблицаДанныхСОтбором
	|		ПО ТаблицаКодыТоваров.КодТовараSKU = ТаблицаДанныхСОтбором.SKU
	|ГДЕ
	|	НЕ ТаблицаДанныхСОтбором.Номенклатура ЕСТЬ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	SKU,
	|	ЭтоГруппа УБЫВ";
	
	ВыгрузкаНаВесы = РеквизитыПравила.ТипПодключаемогоОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	
	Если ВыгрузкаНаВесы Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//Условия" ,"");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Товары", ДанныеОтчета);
	Запрос.УстановитьПараметр("ПравилоОбмена", ПравилоОбмена);
	Запрос.УстановитьПараметр("ТолькоСУстановленнымиЦенами", ТолькоСУстановленнымиЦенами);
	Результат = Запрос.Выполнить();
	
	СписокТоваров = Запрос.Выполнить().Выгрузить();
	
	Возврат СписокТоваров;
	
КонецФункции

Процедура ДобавитьГруппыНоменклатуры(Товары, МассивНоменклатур)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СпрНоменклатура.Родитель КАК Номенклатура,
	|	МАКСИМУМ(КодыТоваровSKU.SKU) КАК SKU,
	|	СпрНоменклатура.Родитель.Родитель КАК Группа
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|		ПО СпрНоменклатура.Родитель = КодыТоваровSKU.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKUГруппы
	|		ПО СпрНоменклатура.Родитель.Родитель = КодыТоваровSKUГруппы.Номенклатура
	|ГДЕ
	|	СпрНоменклатура.Ссылка В(&МассивНоменклатур)
	|	И НЕ СпрНоменклатура.Родитель = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	СпрНоменклатура.Родитель,
	|	КодыТоваровSKUГруппы.SKU,
	|	СпрНоменклатура.Родитель.Родитель";
	
	Запрос.УстановитьПараметр("МассивНоменклатур", МассивНоменклатур);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Номенклатура   = Выборка.Номенклатура;
			НоваяСтрока.SKU            = Выборка.SKU;
			НоваяСтрока.Группа         = Выборка.Группа;
			НоваяСтрока.ЭтоГруппа      = Истина;
			НоваяСтрока.Весовой        = Ложь;
			НоваяСтрока.Цена           = 0;
		КонецЦикла;
		
		МассивНоменклатур = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Номенклатура");
		
		ДобавитьГруппыНоменклатуры(Товары, МассивНоменклатур);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсПечати

Функция СформироватьПечатнуюФормуКодыТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КодыТоваров";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.КодыТоваров");
	ПервыйДокумент = Истина;
	
	Для Каждого Объект Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ВыгрузкаНаВесы = Объект.ТипПодключаемогоОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		Если ВыгрузкаНаВесы Тогда
			ОбластьМакета.Параметры.ТекстЗаголовка = НСтр("ru = 'Коды товаров PLU для весов с печатью этикеток'");
		Иначе
			ОбластьМакета.Параметры.ТекстЗаголовка = НСтр("ru = 'Коды товаров SKU для кассы ККМ Offline'"); 
		КонецЕсли;
		ОбластьМакета.Параметры.ПравилоОбмена  = Объект;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|Товар");   
		ОбластьКод   = Макет.ПолучитьОбласть("ШапкаТаблицы|Код");
		Если ВыгрузкаНаВесы Тогда
			ОбластьКод.Параметры.ЗаголовокКода = "PLU"; 
		Иначе
			ОбластьКод.Параметры.ЗаголовокКода = "SKU"; 
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьКод);
		ТабличныйДокумент.Присоединить(ОбластьТовар);
		
		ОбластьКод   = Макет.ПолучитьОбласть("Строка|Код");
		ОбластьТовар = Макет.ПолучитьОбласть("Строка|Товар");
		
		Товары = ПолучитьТоварыДляПечати(Объект);
		Для Каждого СтрокаТЧ Из Товары Цикл
			
			Если ВыгрузкаНаВесы И СтрокаТЧ.ЕстьОшибки Тогда
				Продолжить;
			КонецЕсли;
			
			ОбластьКод.Параметры.Код = СтрокаТЧ.PLU;
			ТабличныйДокумент.Вывести(ОбластьКод);
			ОбластьТовар.Параметры.Товар = СтрокаТЧ.Наименование;
			ТабличныйДокумент.Присоединить(ОбластьТовар);
			
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Вывести подписи.
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Ответственный = Пользователи.ТекущийПользователь();
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Объект);
	
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Сформировать печатные формы объектов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КодыТоваров") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "КодыТоваров", "Коды товаров", СформироватьПечатнуюФормуКодыТоваров(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
КонецПроцедуры // Печать()

// Заполняет список команд печати справочника "Правила обмена с подключаемым оборудованием offline"
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Коды товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "КодыТоваров";
	КомандаПечати.Представление = НСтр("ru = 'Коды товаров'");
	КомандаПечати.СписокФорм = "ФормаЭлемента,ФормаСписка,ФормаВыбора";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры // ДобавитьКомандыПечати()

// Функция возвращает таблицу товаров с данными о товарам для правила выгрузки с ценами.
//
// Параметры:
//  ПравилоОбмена - <СправочникСсылка.ПравилаОбменаСПодключаемымОборудованием>
//  ВидЦены - <СправочникСсылка.ВидыЦен>
//
// Возвращаемое значение:
//  <ТаблицаЗначений>
//
Функция ПолучитьТоварыДляПечати(ПравилоОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВерхняяГраница = Константы.ВерхняяГраницаДиапазонаSKUВесовогоТовара.Получить();
	НижняяГраница  = Константы.НижняяГраницаДиапазонаSKUВесовогоТовара.Получить();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КодыТоваровPLUНаОборудовании.КодТовараPLU КАК КодТовараPLU,
	|	КодыТоваровPLUНаОборудовании.КодТовараSKU КАК КодТовараSKU,
	|	КодыТоваровSKU.Номенклатура КАК Номенклатура,
	|	
	|	ЕСТЬNULL(КодыТоваровSKU.Номенклатура.Наименование,"""")       КАК НоменклатураНаименование,
	|	ЕСТЬNULL(КодыТоваровSKU.Номенклатура.НаименованиеПолное,"""") КАК НоменклатураНаименованиеПолное,
	|	
	|	КодыТоваровSKU.Характеристика КАК Характеристика,
	|	ЕСТЬNULL(КодыТоваровSKU.Характеристика.Наименование, """")       КАК ХарактеристикаНаименование,
	|	ЕСТЬNULL(КодыТоваровSKU.Номенклатура.ЕдиницаИзмерения.Наименование, """") КАК ЕдиницаИзмеренияНаименование,
	|	
	|	КодыТоваровSKU.Партия КАК Партия,
	|	ЕСТЬNULL(КодыТоваровSKU.Партия.Наименование, """") КАК ПартияНаименование,
	|	ЕСТЬNULL(Штрихкоды.Штрихкод, """") КАК Штрихкод,
	|	КодыТоваровSKU.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	КодыТоваровSKU.Номенклатура.Весовой КАК Весовой
	|	
	|ИЗ
	|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
	|		ПО (КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU)
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК Штрихкоды
	|		ПО КодыТоваровSKU.Номенклатура = Штрихкоды.Номенклатура
	|		И КодыТоваровSKU.Характеристика = Штрихкоды.Характеристика
	|		И КодыТоваровSKU.Партия = Штрихкоды.Партия
	|		И КодыТоваровSKU.ЕдиницаИзмерения = Штрихкоды.ЕдиницаИзмерения
	|ГДЕ
	|	КодыТоваровPLUНаОборудовании.ПравилоОбмена = &ПравилоОбмена
	|	И КодыТоваровSKU.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|ИТОГИ
	|	МАКСИМУМ(Штрихкод)
	|ПО
	|	КодТовараPLU");
	
	НоменклатураВДокументахСервер.ПреобразоватьТекстЗапросаРегистрШтрихкодыНоменклатуры(Запрос.Текст);
	
	Запрос.УстановитьПараметр("ПравилоОбмена", ПравилоОбмена);
	
	ТаблицаТоваров = Новый ТаблицаЗначений;
	ТаблицаТоваров.Колонки.Добавить("PLU",                Новый ОписаниеТипов("Число"));
	ТаблицаТоваров.Колонки.Добавить("SKU",                Новый ОписаниеТипов("Число"));
	ТаблицаТоваров.Колонки.Добавить("Номенклатура",       Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТоваров.Колонки.Добавить("Характеристика",     Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаТоваров.Колонки.Добавить("Партия",             Новый ОписаниеТипов("СправочникСсылка.ПартииНоменклатуры"));
	ТаблицаТоваров.Колонки.Добавить("ЕдиницаИзмерения",   Новый ОписаниеТипов("СправочникСсылка.ЕдиницыИзмерения"));
	ТаблицаТоваров.Колонки.Добавить("Наименование",       Новый ОписаниеТипов("Строка"));
	ТаблицаТоваров.Колонки.Добавить("НаименованиеПолное", Новый ОписаниеТипов("Строка"));
	ТаблицаТоваров.Колонки.Добавить("Штрихкод",           Новый ОписаниеТипов("Строка"));
	ТаблицаТоваров.Колонки.Добавить("Весовой",            Новый ОписаниеТипов("Булево"));
	ТаблицаТоваров.Колонки.Добавить("ЕстьОшибки",         Новый ОписаниеТипов("Булево"));
	
	ВыборкаПоКодам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоКодам.Следующий() Цикл
		
		НоваяСтрока = ТаблицаТоваров.Добавить();
		
		Выборка = ВыборкаПоКодам.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Штрихкод = СокрЛП(Выборка.Штрихкод);
			
			Если Не ЗначениеЗаполнено(НоваяСтрока.PLU) Тогда
				НоваяСтрока.PLU                = Выборка.КодТовараPLU;
				НоваяСтрока.SKU                = Выборка.КодТовараSKU;
				НоваяСтрока.Номенклатура       = Выборка.Номенклатура;
				НоваяСтрока.Характеристика     = Выборка.Характеристика;
				НоваяСтрока.Партия             = Выборка.Партия;
				НоваяСтрока.ЕдиницаИзмерения   = Выборка.ЕдиницаИзмерения;
				НоваяСтрока.Наименование       = УправлениеНебольшойФирмойСервер.ПолучитьПредставлениеНоменклатурыДляПечати(Выборка.Номенклатура, Выборка.Характеристика);
				НоваяСтрока.НаименованиеПолное = УправлениеНебольшойФирмойСервер.ПолучитьПредставлениеНоменклатурыДляПечати(Выборка.Номенклатура, Выборка.Характеристика);
				НоваяСтрока.Весовой            = Выборка.Весовой;
				НоваяСтрока.Штрихкод           = Штрихкод;
			Иначе
				НоваяСтрока.Штрихкод = НоваяСтрока.Штрихкод + ", " + Штрихкод;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ПравилоОбмена.ТипПодключаемогоОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток Тогда
			Если (ПравилоОбмена.СвояНумерацияPLUНаОборудовании И НоваяСтрока.PLU > ПравилоОбмена.МаксимальныйКодPLU)
		     ИЛИ (НоваяСтрока.SKU > ВерхняяГраница) ИЛИ (НоваяСтрока.SKU < НижняяГраница) Тогда
				НоваяСтрока.ЕстьОшибки = Истина;
			КонецЕсли
		КонецЕсли;

	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТаблицаТоваров;
	
КонецФункции


#КонецОбласти

#КонецЕсли