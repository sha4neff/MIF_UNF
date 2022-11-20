
#Область ПрограммныйИнтерфейс

#Область Локализация

// Выполняет переопределяемую команду
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения - форма, в которой расположена команда
//  Команда                 - КомандаФормы     - команда формы
//  ДополнительныеПараметры - Структура        - дополнительные параметры.
//
Процедура ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Обрабатывает нажатие на гиперссылку со статусом обработки документа в ВетИС.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа, в которой произошло нажатие на гиперссылку,
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - значение гиперссылки форматированной строки,
//  СтандартнаяОбработка - Булево - признак стандартной (системной) обработки события.
//
Процедура ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	Если НЕ ЭтоНавигационнаяСсылкаВЕТИС(НавигационнаяСсылкаФорматированнойСтроки) Тогда
		Возврат;
	КонецЕсли;
	
	Объект = Форма[Форма.ПараметрыИнтеграцииГосИС.Получить("ВЕТИС").ИмяРеквизитаФормыОбъект];
	ИнтеграцияВЕТИСКлиент.ОбработкаНавигационнойСсылкиВФормеДокументаОснования(
		Форма,
		Объект,
		Неопределено,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЭтоОповещениеВЕТИС(ИмяСобытия) Тогда
		Возврат;
	КонецЕсли;
	
	МестоВызова = Новый Структура;
	МестоВызова.Вставить("Форма",  Форма);
	МестоВызова.Вставить("Объект", Форма[Форма.ПараметрыИнтеграцииГосИС.Получить("ВЕТИС").ИмяРеквизитаФормыОбъект]);
	
	Событие = Новый Структура;
	Событие.Вставить("Имя",        ИмяСобытия);
	Событие.Вставить("Параметр",   Параметр);
	Событие.Вставить("Источник",   Источник);
	Событие.Вставить("Обработано", Ложь);
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаОповещенияВФормеДокументаОснования(МестоВызова, Событие);
	
	Если Событие.Обработано Тогда
		Возврат;
	КонецЕсли;
	
	Подсистема = Новый Структура;
	Подсистема.Вставить("Имя",ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы());
	Подсистема.Вставить("МодульВызовСервера",ИнтеграцияВЕТИСВызовСервера);
	
	СобытияФормИСКлиент.ОбработкаОповещенияВФормеДокументаОснования(МестоВызова, Событие, Подсистема);
	
КонецПроцедуры

Процедура ПослеЗаписи(Форма, ПараметрыЗаписи) Экспорт
	
	СобытияФормВЕТИСКлиентПереопределяемый.ПослеЗаписи(Форма, ПараметрыЗаписи);
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - ЭлементФормы     - элемент-источник события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриВыбореЭлемента(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ДополнительныеПараметры = Неопределено) Экспорт
	
	//++ Локализация
	СобытияФормВЕТИСКлиентПереопределяемый.ПриВыбореЭлемента(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ДополнительныеПараметры);
	//-- Локализация
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриАктивизацииЯчейки(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	СобытияФормВЕТИСКлиентПереопределяемый.ПриАктивизацииЯчейки(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование, ДополнительныеПараметры) Экспорт
	
	СобытияФормВЕТИСКлиентПереопределяемый.ПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

// Вызывается при наступлении события "Выбор" в табличной части.
// Открывает форму выбранного элемента, если имя реквизита входит в массив имен.
//
// Параметры:
// Форма - ФормаКлиентскогоПриложения - форма объекта,
// ТаблицаФормы - ТаблицаФормы - таблица в которой произошло событие,
// ВыбранноеПоле - ПолеФормы
Процедура ВыборЭлементаТабличнойЧастиОткрытьФормуЭлемента(Форма, ТаблицаФормы, ВыбранноеПоле) Экспорт
	
	МассивИмен = МассивИменРеквизитовФормыОткрытия();
	
	ИмяТабличнойЧасти = ТаблицаФормы.Имя;
	
	Для Каждого ИмяЭлемента Из МассивИмен Цикл
		
		Если Форма.Элементы.Найти(ИмяТабличнойЧасти + ИмяЭлемента) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Форма.Элементы[ИмяТабличнойЧасти + ИмяЭлемента] = ВыбранноеПоле Тогда
			НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ТаблицаФормы.ТекущиеДанные[ИмяЭлемента]);
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылка);
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#Область ВыборОснования

// Открывает форму выбора документа-основания.
//
// Параметры:
//  ФормаВладелец           - ФормаКлиентскогоПриложения   - форма, из которой выполняется команда выбора,
//  ОповещениеПриЗавершении - ОписаниеОповещения - действие формы после завершения выбора,
//  ИмяДокумента            - Строка             - имя метаданных документа-основания.
//  ТипОбъекта              - Тип                - тип документа ВЕТИС для которого происходит выбор основания
//
Процедура ОткрытьФормуВыбораОснованияДокументаИС(Форма, ОповещениеПриЗавершении, Основание, ТипОбъекта) Экспорт
	
	Если ТипОбъекта = Тип("ДокументСсылка.ВходящаяТранспортнаяОперацияВЕТИС")Тогда
		ОткрытьФормуВыбораОснованияВходящейТранспортнойОперации(Форма, ОповещениеПриЗавершении, Основание);
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ИнвентаризацияПродукцииВЕТИС") Тогда
		ОткрытьФормуВыбораОснованияИнвентаризацииПродукции(Форма, ОповещениеПриЗавершении, Основание);
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ИсходящаяТранспортнаяОперацияВЕТИС")Тогда
		ОткрытьФормуВыбораОснованияИсходящейТранспортнойОперации(Форма, ОповещениеПриЗавершении, Основание);
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ПроизводственнаяОперацияВЕТИС") Тогда
		ОткрытьФормуВыбораОснованияПроизводственнойОперации(Форма, ОповещениеПриЗавершении, Основание);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция МассивИменРеквизитовФормыОткрытия()
	
	Массив = Новый Массив;
	Массив.Добавить("ЗаписьСкладскогоЖурнала");
	Массив.Добавить("Продукция");
	Массив.Добавить("ВетеринарноСопроводительныйДокумент");
	
	Возврат Массив;
	
КонецФункции

Функция ЭтоНавигационнаяСсылкаВЕТИС(НавигационнаяСсылка)
	
	Возврат СтрНайти(НавигационнаяСсылка, "ИнтеграцияИС_КомандаНавигационнойСсылки#ВетИС#") > 0;
	
КонецФункции

Функция ЭтоОповещениеВЕТИС(ИмяСобытия)
	
	Возврат СтрНайти(ИмяСобытия, "ИнтеграцияИС_СобытиеОповещения#ВЕТИС#") > 0;
	
КонецФункции

#Область ВыборОснования

// Открывает форму выбора документа-основания по исходящей транспортной операции ВЕТИС.
//
// Параметры:
//  ФормаВладелец           - ФормаКлиентскогоПриложения   - форма, из которой выполняется команда выбора,
//  ОповещениеПриЗавершении - ОписаниеОповещения - действие формы после завершения выбора,
//  ИмяДокумента            - Строка             - имя метаданных документа-основания.
//
Процедура ОткрытьФормуВыбораОснованияИсходящейТранспортнойОперации(Форма, ОповещениеПриЗавершении, ИмяДокумента)
	
	Если НЕ ПроверитьВсяПродукцияСопоставлена(Форма,Форма.Объект.Товары) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура;
	
	СоответствиеПолейДокументовОснованийИТранспортныхОпераций = Новый Соответствие;
	ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ЗаполнитьСоответствиеПолейДокументовОснованийИИсходящейТранспортнойОперации(
		СоответствиеПолейДокументовОснованийИТранспортныхОпераций);
		
	СоответствиеПолеРеквизит = Новый Соответствие;
	СоответствиеПолеРеквизит.Вставить("ГрузоотправительХозяйствующийСубъект", "ГрузоотправительСопоставлениеХСДляОтбораОснований");
	СоответствиеПолеРеквизит.Вставить("ГрузоотправительПредприятие",          "ГрузоотправительСопоставлениеПредприятияДляОтбораОснований");
	СоответствиеПолеРеквизит.Вставить("ГрузополучательХозяйствующийСубъект",  "ГрузополучательСопоставлениеХСДляОтбораОснований");
	СоответствиеПолеРеквизит.Вставить("ГрузополучательПредприятие",           "ГрузополучательСопоставлениеПредприятияДляОтбораОснований");
		
	Для Каждого СоответствиеПоля Из СоответствиеПолейДокументовОснованийИТранспортныхОпераций[ИмяДокумента] Цикл
		Если ЗначениеЗаполнено(СоответствиеПоля.Значение) 
			И ЗначениеЗаполнено(Форма[СоответствиеПолеРеквизит[СоответствиеПоля.Ключ]]) Тогда
			СтруктураОтбора.Вставить(СоответствиеПоля.Значение, Форма[СоответствиеПолеРеквизит[СоответствиеПоля.Ключ]]);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыОткрытияФормы = Новый Структура;
	Если СтруктураОтбора.Количество() > 0 Тогда
		ПараметрыОткрытияФормы.Вставить("Отбор", СтруктураОтбора);
	КонецЕсли;
	
	ДополнительныеПараметры = ПодключаемыеКомандыИСКлиент.ПараметрыЗавершенияВыбораОснования();
	ДополнительныеПараметры.Форма                   = Форма;
	ДополнительныеПараметры.ОповещениеПриЗавершении = ОповещениеПриЗавершении;
	ДополнительныеПараметры.ПерезаполнениеДоступно  = НЕ(Форма.РедактированиеФормыНедоступно ИЛИ Форма.ТолькоПросмотр);
	ИмяФормыВыбора = "Документ." + ИмяДокумента + ".ФормаВыбора";
	
	ПодключаемыеКомандыИСКлиент.ОткрытьФормуВыбораОснования(
		ИмяФормыВыбора,
		ПараметрыОткрытияФормы,
		Форма,
		ДополнительныеПараметры);
	
КонецПроцедуры

// Открывает форму выбора документа-основания по входящей транспортной операции ВЕТИС.
//
// Параметры:
//  ФормаВладелец           - ФормаКлиентскогоПриложения   - форма, из которой выполняется команда выбора,
//  ОповещениеПриЗавершении - ОписаниеОповещения - действие формы после завершения выбора,
//  ИмяДокумента            - Строка             - имя метаданных документа-основания.
//
Процедура ОткрытьФормуВыбораОснованияВходящейТранспортнойОперации(Форма, ОповещениеПриЗавершении, ИмяДокумента)
	
	Если НЕ ПроверитьВсяПродукцияСопоставлена_Уточнение(Форма) 
		ИЛИ НЕ ПроверитьВсяПродукцияСопоставлена(Форма, Форма.Объект.Товары.НайтиСтроки(Новый Структура("ЕстьУточнения",Ложь))) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура;
	
	ДополнительныеПараметры = ПодключаемыеКомандыИСКлиент.ПараметрыЗавершенияВыбораОснования();
	ДополнительныеПараметры.Форма                   = Форма;
	ДополнительныеПараметры.ОповещениеПриЗавершении = ОповещениеПриЗавершении;
	
	ИмяФормыВыбора = "Документ." + ИмяДокумента + ".ФормаВыбора";
	
	ПодключаемыеКомандыИСКлиент.ОткрытьФормуВыбораОснования(
		ИмяФормыВыбора,
		ПараметрыОткрытияФормы,
		Форма,
		ДополнительныеПараметры);
	
КонецПроцедуры

// Открывает форму выбора документа-основания по производственной операции ВЕТИС.
//
// Параметры:
//  ФормаВладелец           - ФормаКлиентскогоПриложения   - форма, из которой выполняется команда выбора,
//  ОповещениеПриЗавершении - ОписаниеОповещения - действие формы после завершения выбора,
//  ИмяДокумента            - Строка             - имя метаданных документа-основания.
//
Процедура ОткрытьФормуВыбораОснованияПроизводственнойОперации(Форма, ОповещениеПриЗавершении, ИмяДокумента)
	
	Если НЕ ПроверитьВсяПродукцияСопоставлена(Форма, Форма.Объект.Товары) 
		ИЛИ НЕ ПроверитьВсяПродукцияСопоставлена(Форма, Форма.Объект.Сырье) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура;
	
	СоответствиеПолей = Новый Соответствие;
	ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ЗаполнитьСоответствиеПолейДокументовОснованийИПроизводственнойОперации(СоответствиеПолей);
	
	Для Каждого СоответствиеПоля Из СоответствиеПолей[ИмяДокумента] Цикл
		Если ЗначениеЗаполнено(СоответствиеПоля.Значение)
			И ЗначениеЗаполнено(Форма[СоответствиеПоля.Ключ+"Соответствие"]) Тогда
			СтруктураОтбора.Вставить(СоответствиеПоля.Значение, Форма[СоответствиеПоля.Ключ+"Соответствие"]);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыОткрытияФормы = Новый Структура;
	Если СтруктураОтбора.Количество() > 0 Тогда
		ПараметрыОткрытияФормы.Вставить("Отбор", СтруктураОтбора);
	КонецЕсли;
	
	ДополнительныеПараметры = ПодключаемыеКомандыИСКлиент.ПараметрыЗавершенияВыбораОснования();
	ДополнительныеПараметры.Форма                   = Форма;
	ДополнительныеПараметры.ОповещениеПриЗавершении = ОповещениеПриЗавершении;
	ДополнительныеПараметры.ПерезаполнениеДоступно  = Не Форма.ТолькоПросмотр;
	
	ИмяФормыВыбора = "Документ." + ИмяДокумента + ".ФормаВыбора";
	
	ПодключаемыеКомандыИСКлиент.ОткрытьФормуВыбораОснования(
		ИмяФормыВыбора,
		ПараметрыОткрытияФормы,
		Форма,
		ДополнительныеПараметры);
	
КонецПроцедуры

// Открывает форму выбора документа-основания по инвентаризации продукции ВЕТИС.
//
// Параметры:
//  ФормаВладелец           - ФормаКлиентскогоПриложения   - форма, из которой выполняется команда выбора,
//  ОповещениеПриЗавершении - ОписаниеОповещения - действие формы после завершения выбора,
//  ИмяДокумента            - Строка             - имя метаданных документа-основания.
//
Процедура ОткрытьФормуВыбораОснованияИнвентаризацииПродукции(Форма, ОповещениеПриЗавершении, ИмяДокумента)
	
	Если НЕ ПроверитьВсяПродукцияСопоставлена(Форма, Форма.Объект.Товары) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура;
	
	СоответствиеПолей = Новый Соответствие;
	ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ЗаполнитьСоответствиеПолейДокументовОснованийИИнвентаризацииПродукции(СоответствиеПолей);
	
	Для Каждого СоответствиеПоля Из СоответствиеПолей[ИмяДокумента] Цикл
		Если ЗначениеЗаполнено(СоответствиеПоля.Значение)
			И ЗначениеЗаполнено(Форма[СоответствиеПоля.Ключ+"Соответствие"]) Тогда
			СтруктураОтбора.Вставить(СоответствиеПоля.Значение, Форма[СоответствиеПоля.Ключ+"Соответствие"]);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыОткрытияФормы = Новый Структура;
	Если СтруктураОтбора.Количество() > 0 Тогда
		ПараметрыОткрытияФормы.Вставить("Отбор", СтруктураОтбора);
	КонецЕсли;
	
	ДополнительныеПараметры = ПодключаемыеКомандыИСКлиент.ПараметрыЗавершенияВыбораОснования();
	ДополнительныеПараметры.Форма                   = Форма;
	ДополнительныеПараметры.ОповещениеПриЗавершении = ОповещениеПриЗавершении;
	ДополнительныеПараметры.ПерезаполнениеДоступно  = НЕ(Форма.РедактированиеФормыНедоступно ИЛИ Форма.ТолькоПросмотр);
	
	ИмяФормыВыбора = "Документ." + ИмяДокумента + ".ФормаВыбора";
	
	ПодключаемыеКомандыИСКлиент.ОткрытьФормуВыбораОснования(
		ИмяФормыВыбора,
		ПараметрыОткрытияФормы,
		Форма,
		ДополнительныеПараметры);
	
КонецПроцедуры

Функция ПроверитьВсяПродукцияСопоставлена(Форма, ТабличнаяЧасть, ИмяТабличнойЧасти = "Товары")
	
	Отказ = Ложь;
	
	Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура)Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Требуется сопоставить номенклатуру'"),,
				СтрШаблон("Объект.%1[%2].Номенклатура",ИмяТабличнойЧасти,СтрокаТабличнойЧасти.НомерСтроки),,
				Отказ);
		КонецЕсли;
	КонецЦикла;

	Возврат НЕ Отказ;
	
КонецФункции

Функция ПроверитьВсяПродукцияСопоставлена_Уточнение(Форма)
	
	Отказ = Ложь;
	
	Для Каждого СтрокаТабличнойЧасти Из Форма.Объект.ТоварыУточнение Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) И ЗначениеЗаполнено(СтрокаТабличнойЧасти.Количество) Тогда
			СтрокиТовары = Форма.Объект.Товары.НайтиСтроки(Новый Структура("ИдентификаторСтроки",СтрокаТабличнойЧасти.ИдентификаторСтроки));
			Если СтрокиТовары.Количество() Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Требуется сопоставить номенклатуру'"),,
					СтрШаблон("Объект.Товары[%1].Номенклатура",СтрокиТовары[0].НомерСтроки),,
				Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат НЕ Отказ;
	
КонецФункции

#КонецОбласти

#КонецОбласти
