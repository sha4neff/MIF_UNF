
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ИдентификаторФормы")
		ИЛИ Параметры.ИдентификаторФормы = Неопределено Тогда
		
		ТекстИсключения = НСтр("ru='Данная обработка предназначена для вызова из ""Настройки ЭДО"".
		|Вызывать ее вручную запрещено.'");
		
		ВызватьИсключение ТекстИсключения;
		Возврат;
		
	КонецЕсли;
	
	ИдентификаторВызывающейФормы = Параметры.ИдентификаторФормы;
	
	ЗагрузитьНастройкиОтбораПоУмолчанию();
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокКнопкиПеренести) Тогда
		Команды["ПеренестиВДокумент"].Заголовок = Параметры.ЗаголовокКнопкиПеренести;
		Команды["ПеренестиВДокумент"].Подсказка = Параметры.ЗаголовокКнопкиПеренести;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПеренестиВДокумент 
		И Объект.Товары.Количество() > 0 Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Подобранные товары отправлены не будут. 
		|Продолжить?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если НЕ ЗавершениеРаботы Тогда
		ПриЗакрытииНаСервере();
		Если Объект.Товары.Количество() = 0 Тогда
			ОповеститьОВыборе(Неопределено);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.ЕдиницаИзмерения = ПолучитьЕдиницуИзмеренияНоменклатуры(ТекущиеДанные.Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды "ПеренестиВДокумент".
//
&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ПеренестиВДокумент = Истина;
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилищеНаСервере();
	ОповеститьОВыборе(АдресВоВременномХранилище);
	
КонецПроцедуры

// Процедура - обработчик команды "ЗаполнитьТаблицуТоваров".
//
&НаКлиенте
Процедура ЗаполнитьТаблицуТоваров(Команда)
	
	Если Объект.Товары.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Таблица товаров будет перезаполнена. Продолжить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьТаблицуТоваровЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
	Иначе
		ЗаполнитьТаблицуТоваровНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		Закрыть();
	КонецЕсли;

КонецПроцедуры

// Процедура выполняет загрузку настроек отбора из настроек по умолчанию.
//
&НаСервере
Процедура ЗагрузитьНастройкиОтбораПоУмолчанию()
	
	СхемаКомпоновкиДанных = Обработки.ЭлектронныеДокументыОтправкаКаталога.ПолучитьМакет("Макет");
	КомпоновщикНастроек.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор)));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	СохраненныеНастройки = ХранилищеОбщихНастроек.Загрузить("ЭлектронныеДокументыОтправкаКаталога", "ОтборТоваров");
	Если ТипЗнч(СохраненныеНастройки) = Тип("ХранилищеЗначения") Тогда
		
		НастройкиОтборов = СохраненныеНастройки.Получить();
		Если ТипЗнч(НастройкиОтборов) = Тип("НастройкиКомпоновкиДанных") Тогда
			КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтборов);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняет заполнение табличной части "Товары".
//
&НаСервере
Процедура ЗаполнитьТаблицуТоваровНаСервере(ПроверятьЗаполнение = Истина)
	
	// Поля необходимые для вывода в таблицу товаров на форме.
	НастройкиПечати = Обработки.ЭлектронныеДокументыОтправкаКаталога.НовыеНастройкиПечати();
	
	НастройкиПечати.ОбязательныеПоля.Добавить("Номенклатура");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
		НастройкиПечати.ОбязательныеПоля.Добавить("ХарактеристикаНоменклатуры");
	КонецЕсли;
	
	НастройкиПечати.ОбязательныеПоля.Добавить("ЕдиницаИзмерения");
	
	НастройкиПечати.КомпоновщикНастроек = КомпоновщикНастроек;
	НастройкиПечати.ИмяМакетаСхемыКомпоновкиДанных = "Макет";
	
	Объект.Товары.Очистить();
	
	// Загрузка сформированного списка товаров.
	СтруктураРезультата = Обработки.ЭлектронныеДокументыОтправкаКаталога.ПодготовитьДанныеДляПечати(НастройкиПечати);
	Для Каждого СтрокаТЧ Из СтруктураРезультата.ТаблицаТоваров Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
			НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаТЧ.ХарактеристикаНоменклатуры;
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.Товары.Обновить();
	
КонецПроцедуры // ЗаполнитьТаблицуТоваровНаСервере()

&НаСервере
Функция ПоместитьВоВременноеХранилищеНаСервере()

	ВедетсяУчетАлкогольнойПродукции = ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийПоАлкогольнойПродукции");
	
	ТаблицаТоваров = Новый ТаблицаЗначений;
	ТаблицаТоваров.Колонки.Добавить("Ид");
	ТаблицаТоваров.Колонки.Добавить("Артикул");
	ТаблицаТоваров.Колонки.Добавить("Наименование");
	ТаблицаТоваров.Колонки.Добавить("НоменклатураНаименование");
	ТаблицаТоваров.Колонки.Добавить("Номенклатура");
	ТаблицаТоваров.Колонки.Добавить("ХарактеристикаНаименование");
	ТаблицаТоваров.Колонки.Добавить("Характеристика");
	ТаблицаТоваров.Колонки.Добавить("БазоваяЕдиница");
	ТаблицаТоваров.Колонки.Добавить("БазоваяЕдиницаКод");
	ТаблицаТоваров.Колонки.Добавить("БазоваяЕдиницаНаименование");
	ТаблицаТоваров.Колонки.Добавить("БазоваяЕдиницаНаименованиеПолное");
	ТаблицаТоваров.Колонки.Добавить("БазоваяЕдиницаМеждународноеСокращение");
	ТаблицаТоваров.Колонки.Добавить("УпаковкаКод");
	ТаблицаТоваров.Колонки.Добавить("УпаковкаНаименование");
	Если ВедетсяУчетАлкогольнойПродукции Тогда
		ТаблицаТоваров.Колонки.Добавить("Свойства");
	КонецЕсли;
	
	Запрос = Обработки.ЭлектронныеДокументыОтправкаКаталога.НовыйЗапросТовары();
	
	Запрос.УстановитьПараметр("ТаблицаТоваров", Объект.Товары.Выгрузить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаТоваров = МассивРезультатов[1].Выбрать();
	Пока ВыборкаТоваров.Следующий() Цикл
		СтрокаТаблицы = ТаблицаТоваров.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ВыборкаТоваров);
		Если ВедетсяУчетАлкогольнойПродукции Тогда
			
			ТаблицаСвойств = Новый ТаблицаЗначений();
			ТаблицаСвойств.Колонки.Добавить("Наименование");
			ТаблицаСвойств.Колонки.Добавить("Значение");
			
			НоваяСтрока = ТаблицаСвойств.Добавить();
			НоваяСтрока.Наименование = "КодВидаАлкогольнойПродукции";
			НоваяСтрока.Значение = ВыборкаТоваров.КодВидаАлкогольнойПродукции;
			
			НоваяСтрока = ТаблицаСвойств.Добавить();
			НоваяСтрока.Наименование = "ИННПроизводителяИмпортера";
			НоваяСтрока.Значение = ВыборкаТоваров.ИННПроизводителяИмпортера;
			
			НоваяСтрока = ТаблицаСвойств.Добавить();
			НоваяСтрока.Наименование = "КПППроизводителяИмпортера";
			НоваяСтрока.Значение = ВыборкаТоваров.КПППроизводителяИмпортера;
			
			НоваяСтрока = ТаблицаСвойств.Добавить();
			НоваяСтрока.Наименование = "ОбъемДАЛ";
			НоваяСтрока.Значение = ВыборкаТоваров.ОбъемДАЛ;
			
			СтрокаТаблицы.Свойства = ТаблицаСвойств;
			
		КонецЕсли;
	КонецЦикла;
	
	УправлениеНебольшойФирмойЭлектронныеДокументыСервер.ОбработатьТаблицуТоваров(ТаблицаТоваров);
	
	ВыборкаВладелец = МассивРезультатов[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если ВыборкаВладелец.Следующий() Тогда
		ТаблицаТоваров.Колонки.Добавить("Штрихкоды");
		ВыборкаТоваров = ВыборкаВладелец.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаТоваров.Следующий() Цикл
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Номенклатура", ВыборкаТоваров.Владелец);
			ПараметрыОтбора.Вставить("Характеристика", ВыборкаТоваров.Характеристика);
			
			МассивСтрок = ТаблицаТоваров.НайтиСтроки(ПараметрыОтбора);
			
			ВыборкаШтрихкодов = ВыборкаТоваров.Выбрать();
			ТаблицаШтрихкодов = Новый ТаблицаЗначений();
			ТаблицаШтрихкодов.Колонки.Добавить("Штрихкод");
			ТаблицаШтрихкодов.Колонки.Добавить("ЕдиницаИзмеренияКод");
			Пока ВыборкаШтрихкодов.Следующий() Цикл
				НовСтрока = ТаблицаШтрихкодов.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтрока, ВыборкаШтрихкодов);
			КонецЦикла;
			
			Для каждого Строка Из МассивСтрок Цикл
				Строка.Штрихкоды = ТаблицаШтрихкодов;
			КонецЦикла;
		КонецЦикла
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаТоваров, ИдентификаторВызывающейФормы);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТаблицуТоваровЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Объект.Товары.Количество() = 0 Или КодВозвратаДиалога.Да = Результат Тогда
		ЗаполнитьТаблицуТоваровНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьЕдиницуИзмеренияНоменклатуры(Номенклатура)

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ЕдиницаИзмерения");

КонецФункции // ПолучитьЕдиницуИзмеренияНоменклатуры()

&НаСервере
Процедура ПриЗакрытииНаСервере()
	ХранилищеОбщихНастроек.Сохранить("ЭлектронныеДокументыОтправкаКаталога", "ОтборТоваров", 
		Новый ХранилищеЗначения(КомпоновщикНастроек.ПолучитьНастройки()));
КонецПроцедуры

#КонецОбласти
