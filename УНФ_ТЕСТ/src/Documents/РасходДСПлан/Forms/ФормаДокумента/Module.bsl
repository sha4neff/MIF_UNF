
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Валюта = Объект.ВалютаДокумента;
	
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	// Документ основание.
	Элементы.ДокументОснованиеНадпись.Заголовок
		= РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(Объект.ДокументОснование);
	
	НовыйМассив = Новый Массив();
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	ПараметрыВыбораДокументаОснования = НовыеПараметры;
	// Конец Документ основание.
	
	ПрочитатьРеквизитыКонтрагента(ЭтотОбъект.РеквизитыКонтрагента, Объект.Контрагент);
	
	АвтоподборКонтактов.ПодключитьОбработчикиСобытияАвтоподбор(ЭтотОбъект);
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = УправлениеСвойствамиПереопределяемый.ЗаполнитьДополнительныеПараметры(Объект,
		"ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// МобильныйКлиент
	УправлениеНебольшойФирмойСервер.НастроитьФормуОбъектаМобильныйКлиент(Элементы);
	// Конец МобильныйКлиент
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеФормой();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обсуждения
	ОбсужденияУНФ.ПослеЗаписиНаСервере(ТекущийОбъект);
	// Конец Обсуждения
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи()
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Дата", Объект.Дата);
	Оповестить("ИзменениеДанныхПлатежногоКалендаря", ПараметрыОповещения,Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПослеЗаписиКонтрагента" Тогда
		Если ЗначениеЗаполнено(Параметр)
			И Объект.Контрагент = Параметр Тогда
			ПрочитатьРеквизитыКонтрагента(ЭтотОбъект.РеквизитыКонтрагента, Параметр);
			УстановитьВидимостьДоговора();
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// Обсуждения
	ОбсужденияУНФКлиент.ОбработкаОповещения(ИмяСобытия, Параметр, Источник, ЭтотОбъект, Объект.Ссылка);
	// Конец Обсуждения
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.Номер = "";
	СтруктураДанные = ПолучитьДанныеОрганизацияПриИзменении(Объект.Организация, Объект.ВалютаДокумента,
		Объект.БанковскийСчет, Объект.Касса);
	Объект.БанковскийСчет = СтруктураДанные.БанковскийСчет;
	Объект.ПодписьРуководителя = СтруктураДанные.ПодписьРуководителя;
	Объект.ПодписьГлавногоБухгалтера = СтруктураДанные.ПодписьГлавногоБухгалтера;
	
	// Касса по умолчанию
	Если СтруктураДанные.Свойство("Касса") Тогда
		Объект.Касса = СтруктураДанные.Касса;
		Объект.ВалютаДокумента = СтруктураДанные.ВалютаДокумента;
	КонецЕсли;
	// Конец Касса по умолчанию
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДокументаПриИзменении(Элемент)
	
	Если Валюта = Объект.ВалютаДокумента Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанные = ПолучитьДанныеВалютаДокументаПриИзменении(Объект.Организация, Валюта, Объект.БанковскийСчет,
		Объект.ВалютаДокумента, Объект.СуммаДокумента, Объект.Дата);
	
	Объект.БанковскийСчет = СтруктураДанные.БанковскийСчет;
	
	Если Объект.СуммаДокумента <> 0 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		ПоказатьВопрос(Новый ОписаниеОповещения("ВалютаДокументаПриИзмененииЗавершение", ЭтотОбъект,
			Новый Структура("СтруктураДанные", СтруктураДанные)), НСтр(
			"ru = 'Изменилась валюта документа. Пересчитать сумму документа?'"), Режим);
		Возврат;
	КонецЕсли;
	ВалютаДокументаПриИзмененииФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДокументаПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	СтруктураДанные = ДополнительныеПараметры.СтруктураДанные;
	
	Ответ = Результат;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.СуммаДокумента = СтруктураДанные.Сумма;
	КонецЕсли;
	
	ВалютаДокументаПриИзмененииФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДокументаПриИзмененииФрагмент()
	
	Валюта = Объект.ВалютаДокумента;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ТипДенежныхСредств.
//
&НаКлиенте
Процедура ТипДенежныхСредствПриИзменении(Элемент)
	
	УстановитьТекущуюСтраницу();
	УстановитьДоступностьРезервирования();
	
КонецПроцедуры // ТипДенежныхСредствПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ДатаПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода Контрагент.
//
&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	СтруктураДанные = ПолучитьДанныеКонтрагентПриИзменении(Объект.Дата, Объект.ВалютаДокумента, Объект.Контрагент, Объект.Организация);
	Объект.Договор = СтруктураДанные.Договор;
	
	УстановитьВидимостьДоговора();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Касса.
//
&НаКлиенте
Процедура КассаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.ВалютаДокумента) Тогда
		Объект.ВалютаДокумента = ПолучитьВалютуПоУмолчаниюКассыНаСервере(Объект.Касса);
	КонецЕсли;
	
	УстановитьДоступностьРезервирования();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода БанковскийСчет.
//
&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	
	УстановитьДоступностьРезервирования();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект,
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьИзмененияРеквизитовПечати(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		ПечатьДокументовУНФКлиент.ОбновитьЗначенияРеквизитовПечати(ЭтотОбъект, Результат.ИзмененныеРеквизиты);
		
		Если Результат.Свойство("Команда") Тогда
			
			Подключаемый_ВыполнитьКоманду(Результат.Команда);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Процедура вызывает обработку заполнения документа по основанию.
//
Процедура ЗаполнитьПоДокументу(ДокОснование)
	
	Документ 			= РеквизитФормыВЗначение("Объект");
	Документ.Заполнить(ДокОснование);
	ЗначениеВРеквизитФормы(Документ, "Объект");
	Модифицированность 	= Истина;
	
КонецПроцедуры // ЗаполнитьПоДокументу()

// Проверяет соответствие валюты денежных средств банковского счета и валюты документа,
// в случае несоответствия определяется банковский счет (касса) по умолчанию.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - Организация документа
//	Валюта - СправочникСсылка.Валюты - Валюта документа
//	БанковскийСчет - СправочникСсылка.БанковскиеСчета - Банковский счет документа
//	Касса - СправочникСсылка.Кассы - Касса документа
//
&НаСервереБезКонтекста
Функция ПолучитьБанковскийСчет(Организация, Валюта)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Организации.БанковскийСчетПоУмолчанию.ВалютаДенежныхСредств = &ВалютаДенежныхСредств
	|			ТОГДА Организации.БанковскийСчетПоУмолчанию
	|		КОГДА (НЕ БанковскиеСчета.БанковскийСчет ЕСТЬ NULL )
	|			ТОГДА БанковскиеСчета.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчет
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			БанковскиеСчета.Ссылка КАК БанковскийСчет
	|		ИЗ
	|			Справочник.БанковскиеСчета КАК БанковскиеСчета
	|		ГДЕ
	|			БанковскиеСчета.ВалютаДенежныхСредств = &ВалютаДенежныхСредств
	|			И БанковскиеСчета.Владелец = &Организация) КАК БанковскиеСчета
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Организации.Ссылка = &Организация");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВалютаДенежныхСредств", Валюта);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.БанковскийСчет;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции // ПолучитьБанковскийСчет()

// Проверяет данные с сервера для процедуры ОрганизацияПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеОрганизацияПриИзменении(Организация, Валюта, БанковскийСчет, Касса)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("БанковскийСчет", ПолучитьБанковскийСчет(Организация, Валюта));
	СтруктураДанные.Вставить("ПодписьРуководителя", Организация.ПодписьРуководителя);
	СтруктураДанные.Вставить("ПодписьГлавногоБухгалтера", Организация.ПодписьГлавногоБухгалтера);
	
	// Касса по умолчанию
	УправлениеНебольшойФирмойСервер.ДобавитьВСтруктуруИнформациюОКассеПоУмолчаниюДляОрганизации(СтруктураДанные,
		Новый Структура("Организация, Касса", Организация, Касса), Валюта, "ВалютаДокумента");
	
	Возврат СтруктураДанные;

КонецФункции // ПолучитьДанныеОрганизацияПриИзменении()

// Проверяет данные с сервера для процедуры ВалютаДокументаПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеВалютаДокументаПриИзменении(Организация, Валюта, БанковскийСчет, НоваяВалюта, СуммаДокумента,
	Дата)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("БанковскийСчет", ПолучитьБанковскийСчет(Организация, НоваяВалюта));
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА КурсыВалют.Кратность <> 0
	|				И (НЕ КурсыВалют.Кратность ЕСТЬ NULL )
	|				И НовыеКурсыВалют.Курс <> 0
	|				И (НЕ НовыеКурсыВалют.Курс ЕСТЬ NULL )
	|			ТОГДА &СуммаДокумента * (КурсыВалют.Курс * НовыеКурсыВалют.Кратность) / (КурсыВалют.Кратность * НовыеКурсыВалют.Курс)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Сумма
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта) КАК КурсыВалют
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &НоваяВалюта) КАК НовыеКурсыВалют
	|		ПО (ИСТИНА)");
	
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("НоваяВалюта", НоваяВалюта);
	Запрос.УстановитьПараметр("СуммаДокумента", СуммаДокумента);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		СтруктураДанные.Вставить("Сумма", Выборка.Сумма);
	Иначе
		СтруктураДанные.Вставить("Сумма", 0);
	КонецЕсли;
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеВалютаДокументаПриИзменении()

// Получает набор данных с сервера для процедуры ДоговорПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	РазностьДат = УправлениеНебольшойФирмойСервер.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить("РазностьДат", РазностьДат);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Получает набор данных с сервера для процедуры КонтрагентПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеКонтрагентПриИзменении(Дата, ВалютаДокумента, Контрагент, Организация)
	
	СтруктураДанные = Новый Структура();
	ДоговорПоУмолчанию = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
	СтруктураДанные.Вставить("Договор", ДоговорПоУмолчанию);
	
	СтруктураДанные.Вставить("ВалютаРасчетов", ДоговорПоУмолчанию.ВалютаРасчетов);
	
	ПрочитатьРеквизитыКонтрагента(ЭтотОбъект.РеквизитыКонтрагента, Контрагент);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеКонтрагентПриИзменении()

&НаСервереБезКонтекста
Процедура ПрочитатьРеквизитыКонтрагента(СтруктураРеквизитов, Знач Контрагент)
	
	Реквизиты = "ВестиРасчетыПоДоговорам";
	
	Если СтруктураРеквизитов = Неопределено Тогда
		СтруктураРеквизитов = Новый Структура(Реквизиты);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контрагент, Реквизиты));
	Иначе
		СтруктураРеквизитов.ВестиРасчетыПоДоговорам = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормой()
	
	УстановитьТекущуюСтраницу();
	УстановитьВидимостьДоговора();
	УстановитьДоступностьРезервирования();
	
КонецПроцедуры

// Устанавливает текущую страницу для вида операции документа.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операции
//
&НаКлиенте
Процедура УстановитьТекущуюСтраницу()
	
	Если Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Безналичные") Тогда
		Элементы.БанковскийСчет.Доступность = Истина;
		Элементы.БанковскийСчет.Видимость 	= Истина;
		Элементы.Касса.Видимость 			= Ложь;
	ИначеЕсли Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные") Тогда
		Элементы.Касса.Доступность 			= Истина;
		Элементы.БанковскийСчет.Видимость 	= Ложь;
		Элементы.Касса.Видимость 			= Истина;
	Иначе
		Элементы.БанковскийСчет.Доступность = Ложь;
		Элементы.БанковскийСчет.Видимость	= Ложь;
		Элементы.Касса.Доступность 			= Ложь;
		Элементы.Касса.Видимость 			= Ложь;
	КонецЕсли;
	
КонецПроцедуры // УстановитьТекущуюСтраницу()

// Процедура устанавливает видимость договора в зависимости от установленного параметра контрагенту.
//
&НаКлиенте
Процедура УстановитьВидимостьДоговора()
	
	Элементы.Договор.Видимость = РеквизитыКонтрагента.ВестиРасчетыПоДоговорам;
	
КонецПроцедуры // УстановитьВидимостьДоговора()

// Процедура устанавливает доступность флага резервирования в зависимости от выбранного способа оплаты.
//
&НаКлиенте
Процедура УстановитьДоступностьРезервирования()
	
	Если ОтключитьРезервирование() Тогда
		Объект.РезервироватьДенежныеСредства = Ложь;
		Элементы.РезервироватьДенежныеСредства.Доступность = Ложь;
	Иначе
		Элементы.РезервироватьДенежныеСредства.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОтключитьРезервирование()
	
	Если Не ЗначениеЗаполнено(Объект.ТипДенежныхСредств) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Безналичные")
		И Не ЗначениеЗаполнено(Объект.БанковскийСчет) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные")
		И Не ЗначениеЗаполнено(Объект.Касса) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Процедура получает валюту кассы по умолчанию.
//
&НаСервереБезКонтекста
Функция ПолучитьВалютуПоУмолчаниюКассыНаСервере(Касса)
	
	Возврат Касса.ВалютаПоУмолчанию;
	
КонецФункции // ПолучитьВалютуПоУмолчаниюКассыНаСервере()

&НаКлиенте
// Процедура вызывается при нажатии кнопки "ЗаполнитьПоОснованию" командной панели
//
Процедура ЗаполнитьПоОснованию(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		
		ТекстСообщения = НСтр("ru = 'Требуется заполнить документ-основание.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.ДокументОснование");
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Документ будет полностью перезаполнен по ""Основанию"". Продолжить выполнение операции?'");
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоОснованиюЗавершение", ЭтотОбъект),
		ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованиюЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ЗаполнитьПоДокументу(Объект.ДокументОснование);
		УправлениеФормой();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеОбъектов

&НаКлиенте
Процедура СохранитьДокументКакШаблон(Параметр) Экспорт
	
	ЗаполнениеОбъектовУНФКлиент.СохранитьДокументКакШаблон(Объект, ОтображаемыеРеквизиты(), Параметр);
	
КонецПроцедуры

&НаСервере
Функция ОтображаемыеРеквизиты()
	
	Возврат ЗаполнениеОбъектовУНФ.ОтображаемыеРеквизиты(ЭтотОбъект);
	
КонецФункции

#КонецОбласти

#Область АвтоподборКонтактов

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	АвтоподборКонтактовКлиент.Подключаемый_ОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_АвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	АвтоподборКонтактовКлиент.Подключаемый_АвтоПодбор(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, Параметры, Ожидание,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область Основание

&НаСервереБезКонтекста
Функция СписокДляВыбораДокументаОснования()
	
	СписокОснований = Новый СписокЗначений;
	
	СписокОснований.Добавить("Документ.СчетФактураПолученный.ФормаВыбора", НСтр("ru = 'Счет-фактура (полученный)'"));
	СписокОснований.Добавить("Документ.АвансовыйОтчет.ФормаВыбора", НСтр("ru = 'Авансовый отчет'"));
	СписокОснований.Добавить("Документ.ОтчетПереработчика.ФормаВыбора", НСтр("ru = 'Отчет переработчика'"));
	СписокОснований.Добавить("Документ.ПриходнаяНакладная.ФормаВыбора", НСтр("ru = 'Приходная накладная'"));
	СписокОснований.Добавить("Документ.ЗаказПоставщику.ФормаВыбора", НСтр("ru = 'Заказ поставщику'"));
	СписокОснований.Добавить("Документ.СчетНаОплатуПоставщика.ФормаВыбора", НСтр("ru = 'Счет на оплату (полученный)'"));
	СписокОснований.Добавить("Документ.ДополнительныеРасходы.ФормаВыбора", НСтр("ru = 'Дополнительные расходы'"));
	СписокОснований.Добавить("Документ.ПлатежнаяВедомость.ФормаВыбора", НСтр("ru = 'Платежная ведомость'"));
	Если ПолучитьФункциональнуюОпцию("ПриемТоваровНаКомиссию") Тогда
		СписокОснований.Добавить("Документ.ОтчетКомитенту.ФормаВыбора", НСтр("ru = 'Отчет комитенту'"));
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("КредитыИЗаймы") Тогда
		СписокОснований.Добавить("Документ.ДоговорКредитаИЗайма.ФормаВыбора", НСтр("ru = 'Договор кредита (займа)'"));
	КонецЕсли;
	
	СписокОснований.СортироватьПоПредставлению(НаправлениеСортировки.Возр);
	
	Возврат СписокОснований;
	
КонецФункции

&НаКлиенте
Процедура ДокументОснованиеНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НЕ ТолькоПросмотр И НавигационнаяСсылкаФорматированнойСтроки = "удалить" Тогда
		
		Объект.ДокументОснование = Неопределено;
		Элементы.ДокументОснованиеНадпись.Заголовок = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(Неопределено);
		Модифицированность = Истина;
		
	ИначеЕсли НЕ ТолькоПросмотр И НавигационнаяСсылкаФорматированнойСтроки = "заполнить" Тогда
		
		ЗаполнитьПоОснованиюНачало();
		
	ИначеЕсли НЕ ТолькоПросмотр И НавигационнаяСсылкаФорматированнойСтроки = "выбрать" Тогда
		
		// Выбрать основание
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыборТипаОснованияЗавершение", ЭтотОбъект);
		ПоказатьВыборИзМеню(ОписаниеОповещения, СписокДляВыбораДокументаОснования(), Элемент);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "открыть" Тогда
		
		РаботаСФормойДокументаКлиент.ОткрытьФормуДокументаПоСсылке(Объект.ДокументОснование);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборТипаОснованияЗавершение(ВыбранныйЭлемент, Параметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметровОтбора = Новый Структура();
	Для каждого элОтбора Из ПараметрыВыбораДокументаОснования Цикл
		ИмяПоляОтбора = СтрЗаменить(элОтбора.Имя,"Отбор.","");
		СтруктураПараметровОтбора.Вставить(ИмяПоляОтбора, элОтбора.Значение);
	КонецЦикла;
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыбратьОснованиеЗавершение", ЭтотОбъект);
	ОткрытьФорму(ВыбранныйЭлемент.Значение, СтруктураПараметровОтбора, ЭтотОбъект,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОснованиеЗавершение(ВыбранноеЗначение, Параметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ДокументОснование = ВыбранноеЗначение;
	Элементы.ДокументОснованиеНадпись.Заголовок = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(ВыбранноеЗначение);
	Модифицированность = Истина;
	
	ЗаполнитьПоОснованиюНачало();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованиюНачало()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоОснованиюЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Заполнить документ по выбранному основанию?'"),
		РежимДиалогаВопрос.ДаНет, 0);
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ДекорацияПечатьНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьИзмененияРеквизитовПечати", ЭтотОбъект);
	ОткрытьФорму("Обработка.РеквизитыПечати.Форма.РеквизитыПечатиРасходДСПлан",
		Новый Структура("КонтекстПечати", Объект), ЭтотОбъект,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДополнительныйРеквизит(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущийНаборСвойств",
		ПредопределенноеЗначение("Справочник.НаборыДополнительныхРеквизитовИСведений.Документ_РасходДСПлан"));
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Ложь);
	
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта", ПараметрыФормы,,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
// @skip-warning
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
