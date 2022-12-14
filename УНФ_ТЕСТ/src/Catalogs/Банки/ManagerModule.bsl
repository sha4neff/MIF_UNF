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

// Функция формирует результат запроса по классификатору банков
// с отбором по Код, корреспондентскому счету, наименованию или городу.
//
// Параметры:
//	Код - Строка (9) - Код банка
//	КорСчет - Строка (20) - Корреспондентский счет банка
//
// Возвращаемое значение:
//	РезультатЗапроса - Результат запроса по классификатору.
//
Функция ПолучитьРезультатЗапросаПоКлассификатору(Код, КоррСчет) Экспорт
	
	Если ПустаяСтрока(Код) И ПустаяСтрока(КоррСчет) Тогда
		Запрос = Новый Запрос;
		Возврат Запрос.Выполнить().Выбрать();
	КонецЕсли;
	
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.Текст =
	"ВЫБРАТЬ
	|	КлассификаторБанков.Код КАК Код,
	|	КлассификаторБанков.Наименование,
	|	КлассификаторБанков.КоррСчет,
	|	КлассификаторБанков.Город,
	|	КлассификаторБанков.Адрес,
	|	КлассификаторБанков.Ссылка
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанков
	|ГДЕ
	|	НЕ КлассификаторБанков.ЭтоГруппа
	|{ГДЕ
	|	КлассификаторБанков.Код,
	|	КлассификаторБанков.КоррСчет}
	|{УПОРЯДОЧИТЬ ПО
	|	Наименование}";
	
	Отбор = ПостроительЗапроса.Отбор;
	
	Если ЗначениеЗаполнено(Код) Тогда
		Отбор.Добавить("Код");
		Отбор.Код.Значение = СокрЛП(Код);
		Отбор.Код.ВидСравнения = ВидСравнения.Содержит;
		Отбор.Код.Использование = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КоррСчет) Тогда
		Отбор.Добавить("КоррСчет");
		Отбор.КоррСчет.Значение = СокрЛП(КоррСчет);
		Отбор.КоррСчет.ВидСравнения = ВидСравнения.Содержит;
		Отбор.КоррСчет.Использование = ЗначениеЗаполнено(КоррСчет);
	КонецЕсли;
	
	Порядок = ПостроительЗапроса.Порядок;
	Порядок.Добавить("Наименование");
	
	ПостроительЗапроса.Выполнить();
	РезультатЗапроса = ПостроительЗапроса.Результат;
	
	Возврат РезультатЗапроса;
	
КонецФункции

// Функция получает таблицу ссылок на банки по Коду или корреспондетскому счету.
//
// Параметры:
//	Поле - Строка - Имя поля (Код или КоррСчет)
//	Значение - Строка - Значение Код или Корреспондентского счета
//
// Возвращаемое значение:
//	ТаблицаЗначений - Найденые банки
//
Функция ПолучитьТаблицуБанковПоРеквизитам(Поле, Значение) Экспорт
	
	ТаблицаБанков = Новый ТаблицаЗначений;
	Колонки = ТаблицаБанков.Колонки;
	Колонки.Добавить("Ссылка");
	Колонки.Добавить("Код");
	Колонки.Добавить("КоррСчет");
	
	ЭтоКод = Ложь;
	ЭтоКоррСчет = Ложь;
	Если СтрНайти(Поле, "Код") <> 0 Тогда
		ЭтоКод = Истина;
	ИначеЕсли СтрНайти(Поле, "КоррСчет") <> 0 Тогда
		ЭтоКоррСчет = Истина;
	КонецЕсли;
	
	Если ЭтоКод И СтрДлина(Значение) > 6
		ИЛИ ЭтоКоррСчет И СтрДлина(Значение) > 10 Тогда
		
		Если ЭтоКод Тогда
			
			РезультатЗапроса = ПолучитьДанныеИзСправочникаБанков(Значение, "");
			
		ИначеЕсли ЭтоКоррСчет Тогда
			
			РезультатЗапроса = ПолучитьДанныеИзСправочникаБанков("", Значение);
			
		КонецЕсли;
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				НоваяСтрока = ТаблицаБанков.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ТаблицаБанков.Количество() = 0 Тогда
			
			ДобавитьБанкиИзКлассификатора(
				?(ЭтоКод, Значение, ""), // Код
				?(ЭтоКоррСчет, Значение, ""), // КоррСчет
				ТаблицаБанков
			);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаБанков;
	
КонецФункции

// Процедура инициализирует обновление справочника банков.
//
Процедура ОбновитьБанкиИзКлассификатора(СтруктураПараметров, АдресХранилища) Экспорт
	
	МассивБанков        = Новый Массив();
	ДанныеДляЗаполнения = Новый Структура();
	
	УспешноОбновлены = РаботаСБанкамиПереопределяемый.ОбновитьБанкиИзКлассификатора(, РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
	
	ДанныеДляЗаполнения.Вставить("УспешноОбновлены",   УспешноОбновлены);
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры // ОбновитьБанкиИзКлассификатора()

Функция СтранаПоSWIFT(СВИФТБИК) Экспорт
	
	КодСтраны = УправлениеНебольшойФирмойКлиентСервер.КодСтраныSWIFT(СВИФТБИК);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодАльфа2", КодСтраны);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтраныМира.Ссылка
	|ИЗ
	|	Справочник.СтраныМира КАК СтраныМира
	|ГДЕ
	|	СтраныМира.КодАльфа2 = &КодАльфа2";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		ВсеСтраны = КонтактнаяИнформацияУНФ.ТаблицаКлассификатора();
		ВсеСтраны.Индексы.Добавить("КодАльфа2");
		ОписаниеСтраны = ВсеСтраны.Найти(КодСтраны);
		Если ОписаниеСтраны <> Неопределено Тогда
			Страна = Справочники.СтраныМира.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(Страна, ОписаниеСтраны);
			Страна.Записать();
			
			Возврат Страна.Ссылка;
		Иначе
			Возврат Справочники.СтраныМира.Россия;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Возвращает структуру реквизитов банка из справочника Банки.
//
// Параметры:
//  СсылкаНаБанк - СправочникСсылка.Банки - ссылка на банк, для которого требуется получить реквизиты.
// 
// Возвращаемое значение:
//  Структура - см. описание возвращаемого значения в функции НоваяСтруктураРеквизитовБанка()
//
Функция РеквизитыБанка(СсылкаНаБанк) Экспорт
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаБанк,"Код,СВИФТБИК,Наименование,РучноеИзменение,Страна,КоррСчет");
	
	РеквизитыБанка = НоваяСтруктураРеквизитовБанка();
	РеквизитыБанка.Ссылка = СсылкаНаБанк;
	РеквизитыБанка.Код = ЗначенияРеквизитов.Код;
	РеквизитыБанка.СВИФТБИК = ЗначенияРеквизитов.СВИФТБИК;
	РеквизитыБанка.Наименование = ЗначенияРеквизитов.Наименование;
	РеквизитыБанка.ДеятельностьПрекращена = ДеятельностьБанкаПрекращена(ЗначенияРеквизитов.РучноеИзменение);
	РеквизитыБанка.ЯвляетсяБанкомРФ = (ЗначенияРеквизитов.Страна = Справочники.СтраныМира.Россия);
	РеквизитыБанка.КоррСчет = ЗначенияРеквизитов.КоррСчет;
	
	Возврат РеквизитыБанка;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет новый банк из классификатора
// по значению Код или корреспондентскому счету.
//
// Параметры:
//	Код - Строка (9) - Код банка
//	КоррСчет - Строка (20) - Корреспондентский счет банка
//	ТаблицаБанков - ТаблицаЗначений - Таблица банков
//
Процедура ДобавитьБанкиИзКлассификатора(Код, КоррСчет, ТаблицаБанков)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = ПолучитьРезультатЗапросаПоКлассификатору(Код, КоррСчет);
	
	МассивБанковИзКлассификатора = Новый Массив;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивБанковИзКлассификатора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Если МассивБанковИзКлассификатора.Количество() > 0 Тогда
		
		МассивБанков = РаботаСБанкамиПереопределяемый.ПодобратьБанкИзКлассификатора(МассивБанковИзКлассификатора);
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	БанкНайден = Ложь;
	Для каждого НайденныйБанк Из МассивБанков Цикл
		
		ИскатьПоКоду		= НЕ ПустаяСтрока(Код) И НЕ НайденныйБанк.ЭтоГруппа;
		ИскатьПоКоррСчету	= НЕ ПустаяСтрока(КоррСчет) И НЕ НайденныйБанк.ЭтоГруппа;
		
		Если ИскатьПоКоду 
			И ИскатьПоКоррСчету
			И НайденныйБанк.Код = Код 
			И НайденныйБанк.КоррСчет = КоррСчет Тогда
			
			БанкНайден = Истина;
			
		ИначеЕсли ИскатьПоКоду 
			И СтрНайти(НайденныйБанк.Код, Код) > 0 Тогда
			
			БанкНайден = Истина;
			
		ИначеЕсли ИскатьПоКоррСчету 
			И СтрНайти(НайденныйБанк.КоррСчет, КоррСчет) Тогда
			
			БанкНайден = Истина;
			
		КонецЕсли;
		
		Если БанкНайден Тогда
			
			НоваяСтрока = ТаблицаБанков.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, НайденныйБанк);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает источник данных ориентируясь на режим работы конфигурации
// 
Функция ПолучитьИсточникДанных()
	
	Запрос = Новый Запрос("ВЫБРАТЬ * ИЗ Справочник.Банки");
	Возврат Запрос.Выполнить();
	
КонецФункции // ПолучитьИсточникДанных()

// Добавить элемент отбора построителя отчета
//
Процедура ДобавитьЭлементОтбораПостроителяОтбора(Построитель, Имя, Значение, ЗначениеВидаСравнения)
	
	Если ЗначениеЗаполнено(Значение) Тогда
		
		ЭлементОтбора = Построитель.Отбор.Добавить(Имя);
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	ЭлементОтбора.ВидСравнения = ЗначениеВидаСравнения;
	ЭлементОтбора.Значение = Значение;
	ЭлементОтбора.Использование = Истина;
	
КонецПроцедуры //ДобавитьЭлементОтбораПостроителяОтбора()

// Функция формирует результат запроса по классификатору банков
// с отбором по Код, корреспондентскому счету, наименованию банка, городу
//
// - разделение даных включено, источником данных выступает справочник классификатор банков
// - разделение даных не включено, источником данных выступает макет, приложенный к справочнику банков
//
// Параметры:
//	Код - Строка (9) - Код банка
//	КорСчет - Строка (20) - Корреспондентский счет банка
//
// Возвращаемое значение:
//	РезультатЗапроса - Результат запроса по классификатору.
//
Функция ПолучитьДанныеИзСправочникаБанков(Код, КоррСчет)
	
	Построитель = Новый ПостроительЗапроса;
	Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ПолучитьИсточникДанных());
	
	ДобавитьЭлементОтбораПостроителяОтбора(Построитель, "Код", 		СокрЛП(Код), 		ВидСравнения.Содержит);
	ДобавитьЭлементОтбораПостроителяОтбора(Построитель, "КоррСчет", СокрЛП(КоррСчет),	ВидСравнения.Содержит);
	
	Построитель.Выполнить();
	
	Возврат Построитель.Результат;
	
КонецФункции // ПолучитьРезультатЗапросаПоКлассификаторуВРазделенномРежиме()

Функция НоваяСтруктураРеквизитовБанка()
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Код", "");
	СтруктураРеквизитов.Вставить("СВИФТБИК", "");
	СтруктураРеквизитов.Вставить("Наименование", "");
	СтруктураРеквизитов.Вставить("Ссылка", Справочники.Банки.ПустаяСсылка());
	СтруктураРеквизитов.Вставить("ДеятельностьПрекращена", Ложь);
	СтруктураРеквизитов.Вставить("ЯвляетсяБанкомРФ", Ложь);
	СтруктураРеквизитов.Вставить("КоррСчет", "");

	Возврат СтруктураРеквизитов;
	
КонецФункции

// Возвращает признак недействующего банка по реквизиту банка РучноеИзменение.
//
// Параметры:
//  РучноеИзменение - Число - если 3, то деятельность прекращена.
// 
// Возвращаемое значение:
//  Булево -  признак недействующего банка.
//
Функция ДеятельностьБанкаПрекращена(РучноеИзменение)
	
	Возврат ?(РучноеИзменение = 3, Истина, Ложь);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Код");
	Поля.Добавить("Наименование");
	Поля.Добавить("СВИФТБИК");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если УправлениеНебольшойФирмойКлиентСервер.ЭтоБИКБанкаРФ(Данные.Код) Тогда
		Представление = СокрЛП(Данные.Код) + " " + СокрЛП(Данные.Наименование);
	Иначе
		КодЗарубежногоБанка = " " + ?(ПустаяСтрока(Данные.СВИФТБИК), Данные.Код, Данные.СВИФТБИК); 
		Представление = СокрЛП(КодЗарубежногоБанка) + " " + СокрЛП(Данные.Наименование);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОбновления

Процедура УстановитьСтрануВБанках() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Банки.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Банки КАК Банки
	|ГДЕ
	|	Банки.Страна = &ПустаяСтрана
	|	И НЕ Банки.ЭтоГруппа";
	
	Запрос.УстановитьПараметр("ПустаяСтрана", Справочники.СтраныМира.ПустаяСсылка());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СтранаРФ = Справочники.СтраныМира.Россия;
	Пока Выборка.Следующий() Цикл
		
		ВыбранныйБанк = Выборка.Ссылка.ПолучитьОбъект();
		ВыбранныйБанк.Страна = СтранаРФ;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВыбранныйБанк);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли