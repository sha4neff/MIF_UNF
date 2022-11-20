
// Номер ГТД расшифровывается следующим образом:
// элемент 1 - код таможенного органа, зарегистрировавшего ДТ [ ГТД ].
// элемент 2 - дата регистрации ДТ [ ГТД ] (день, месяц, две последние цифры года);
// элемент 3 - порядковый номер ДТ [ ГТД ], присваиваемый по журналу регистрации ДТ [ ГТД ] таможенным органом,
// зарегистрировавшим ДТ [ ГТД ] (начинается с единицы с каждого календарного года). Все элементы указываются через знак
// разделителя "/", пробелы между элементами не допускаются.

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМЫ ДОКУМЕНТА

&НаСервере
// Функция помещает результаты работы (табличную часть) в хранилище
//
Функция ЗаписатьПодборВХранилище() 
		
	Возврат ПоместитьВоВременноеХранилище(
		Запасы.Выгрузить(),
		?(УникальныйИдентификаторФормыВладельца = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"), Неопределено, УникальныйИдентификаторФормыВладельца)
										);
	
КонецФункции

// Процедура устанавливает значение в отмеченных строках табличной части
//
&НаСервере
Процедура УстановитьЗначенияВОтмеченныхСтрокахТабличнойЧасти()
	
	Для каждого СтрокаЗапасов Из Запасы Цикл
		
		Если НЕ СтрокаЗапасов.Отметка Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если НЕ СтрокаЗапасов.ЭтоЗапас Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		СтрокаЗапасов.СтранаПроисхождения = СтранаПроисхождения;
		СтрокаЗапасов.НомерГТД = НомерГТД;
		
	КонецЦикла;
	
КонецПроцедуры //УстановитьЗначенияВОтмеченныхСтрокахТабличнойЧасти()

// Инвертирует значения поля Отметка во всех строках табличной части Запасы
//
&НаСервере
Процедура ИнвертироватьОтметкиНаСервере()
	
	Для каждого СтрокаЗапасов Из Запасы Цикл
		
		СтрокаЗапасов.Отметка = НЕ СтрокаЗапасов.Отметка;
		
	КонецЦикла;
	
КонецПроцедуры // ИнвертироватьОтметкиНаСервере()

// Процедура устанавливает переданное значение для поля Отметка в строках табличной части Запасы
//
// ЗначениеОтметки (булево) - Значение, которое будет установлено в поле Отметка
// СтранаПроисхождения (Справочник.СтраныМира) - Страна происхождения, по которой будут отобраны строки для установления
// отметки.
//			Если не указана, значение будет присвоено во всех строках табличной части.
//
&НаСервере
Процедура УстановитьОтметкуВСтроках(ЗначениеОтметки, СтранаПроисхождения = Неопределено)
	
	Для каждого СтрокаЗапасов Из Запасы Цикл
		
		Если СтранаПроисхождения = Неопределено
			Или СтрокаЗапасов.СтранаПроисхождения = СтранаПроисхождения Тогда
		
			СтрокаЗапасов.Отметка = ЗначениеОтметки;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // УстановитьОтметкуВСтроках()

// Получает значения табличной части Запаса документа, для которого выполняется заполнение
//
&НаСервере
Процедура ПолучитьЗапасыИзХранилища(АдресЗапасовВХранилище)
	
	Запасы.Загрузить(ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище));
	
	Для каждого СтрокаЗапасов Из Запасы Цикл
		
		Если ЗначениеЗаполнено(СтрокаЗапасов.Номенклатура) Тогда
			
			СтрокаЗапасов.ЭтоЗапас = ((СтрокаЗапасов.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас)
								ИЛИ (СтрокаЗапасов.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат));
			
		Иначе
			
			СтрокаЗапасов.ЭтоЗапас = Ложь;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаЗапасов.СтранаПроисхождения) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтранаПроисхождения) Тогда
			
			СтранаПроисхождения = СтрокаЗапасов.СтранаПроисхождения;
			
		КонецЕсли;
		
		СтрокаЗапасов.Отметка = (СтранаПроисхождения = СтрокаЗапасов.СтранаПроисхождения);
		
	КонецЦикла;
	
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаДокумента = Параметры.ДатаДокумента;
	
	ПолучитьЗапасыИзХранилища(Параметры.АдресЗапасовВХранилище);
	
	УникальныйИдентификаторФормыВладельца = Параметры.УникальныйИдентификаторФормыВладельца;
	
КонецПроцедуры // ПриСозданииНаСервере()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ РЕКВИЗИТОВ ФОРМЫ

&НаКлиенте
Процедура ТаблицаЗапасовНомерГТДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ Элементы.ТаблицаЗапасов.ТекущиеДанные.ЭтоЗапас Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения = НСтр("ru = 'Указать номер ГТД возможно только для номенклатуры с типом <Запас>.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗапасовНомерГТДПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.ТаблицаЗапасов.ТекущиеДанные;
	Если НЕ ДанныеСтроки.ЭтоЗапас Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения = НСтр("ru = 'Указать номер ГТД возможно только для номенклатуры с типом <Запас>.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		ДанныеСтроки.НомерГТД = Неопределено;
		
	КонецЕсли;
	
	ДатаРегистрацииГТД = ГрузовыеТаможенныеДекларацииКлиент.ВыделитьДатуИзНомераГТД(ДанныеСтроки.НомерГТД);
	Если ДатаРегистрацииГТД > ДатаДокумента Тогда
		
		ТекстВопроса = Нстр("ru = 'Выбрана ГТД, у которой дата регистрации старше даты документа. 
			|Продолжить?'");
		
		Оповещение = Новый ОписаниеОповещения("НомерГТДПриОкончанииПроверкиДаты", ЭтотОбъект, "ДанныеСтроки.НомерГТД");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗапасовСтранаПроисхожденияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ Элементы.ТаблицаЗапасов.ТекущиеДанные.ЭтоЗапас Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения = НСтр("ru = 'Указать страну происхождения возможно только для номенклатуры с типом <Запас>.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗапасовСтранаПроисхожденияПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.ТаблицаЗапасов.ТекущиеДанные;
	Если НЕ ДанныеСтроки.ЭтоЗапас Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения = НСтр("ru = 'Указать страну происхождения возможно только для номенклатуры с типом <Запас>.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		ДанныеСтроки.СтранаПроисхождения = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомерГТДПриИзменении(Элемент)
	
	Если ПустаяСтрока(НомерГТД) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДатаРегистрацииГТД = ГрузовыеТаможенныеДекларацииКлиент.ВыделитьДатуИзНомераГТД(Строка(НомерГТД));
	Если ДатаРегистрацииГТД > ДатаДокумента Тогда
		
		ТекстВопроса = Нстр("ru = 'Выбрана ГТД, у которой дата регистрации старше даты документа. 
			|Продолжить?'");
		
		Оповещение = Новый ОписаниеОповещения("НомерГТДПриОкончанииПроверкиДаты", ЭтотОбъект, "НомерГТД");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомерГТДПриОкончанииПроверкиДаты(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		
		Если ДополнительныеПараметры = "НомерГТД" Тогда
			
			НомерГТД = Неопределено;
			
		ИначеЕсли ДополнительныеПараметры = "ДанныеСтроки.НомерГТД" Тогда
			
			ДанныеСтроки = Элементы.ТаблицаЗапасов.ТекущиеДанные;
			ДанныеСтроки.НомерГТД = Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Процедуры управление установки/очистки отметки в строках

// Процедура - обработчик команды УстановитьОтметкуВоВсехСтроках
//
&НаКлиенте
Процедура УстановитьОтметкуВоВсехСтроках(Команда)
	
	УстановитьОтметкуВСтроках(Истина, );
	
КонецПроцедуры //УстановитьОтметкуВоВсехСтроках()

// Процедура - обработчик команды СнятьОтметкуВоВсехСтроках
//
&НаКлиенте
Процедура СнятьОтметкуВоВсехСтроках(Команда)
	
	УстановитьОтметкуВСтроках(Ложь, );
	
КонецПроцедуры //СнятьОтметкуВоВсехСтроках()

// Процедура - обработчик команды ИнвертироватьОтметки (изменяет значение на противоположное)
//
&НаКлиенте
Процедура ИнвертироватьОтметки(Команда)
	
	ИнвертироватьОтметкиНаСервере();
	
КонецПроцедуры //ИнвертироватьОтметки()

// Процедура - обработчик команды УстановитьОтметкуДляСтрокСАналогичнойСтраной
//
&НаКлиенте
Процедура УстановитьОтметкуДляСтрокСАналогичнойСтраной(Команда)
	
	ДанныеТекущейCтроки = Элементы.ТаблицаЗапасов.ТекущиеДанные;
	
	Если ДанныеТекущейCтроки = Неопределено Тогда
		
		ТекстСообщения = НСтр("ru = 'Выделите строку табличной части и повторите нажатие...'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
		
	КонецЕсли;
	
	СтранаПроисхождения = ДанныеТекущейCтроки.СтранаПроисхождения;
	
	УстановитьОтметкуВСтроках(Истина, ДанныеТекущейCтроки.СтранаПроисхождения);
	
КонецПроцедуры // УстановитьОтметкуДляСтрокСАналогичнойСтраной()

// Процедура - обработчик команды СнятьОтметкуДляСтрокСАналогичнойСтраной
//
&НаКлиенте
Процедура СнятьОтметкуДляСтрокСАналогичнойСтраной(Команда)
	
	ДанныеТекущейCтроки = Элементы.ТаблицаЗапасов.ТекущиеДанные;
	
	Если ДанныеТекущейCтроки = Неопределено Тогда
		
		ТекстСообщения = НСтр("ru = 'Выделите строку табличной части и повторите нажатие...'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
		
	КонецЕсли;
	
	УстановитьОтметкуВСтроках(Ложь, ДанныеТекущейCтроки.СтранаПроисхождения);
	
КонецПроцедуры // СнятьОтметкуДляСтрокСАналогичнойСтраной()

// Конец. Процедуры управление установки/очистки отметки в строках

// Процедура - обработчик команды УстановитьНомерГТД
//
&НаКлиенте
Процедура УстановитьЗначения(Команда)
	
	УстановитьЗначенияВОтмеченныхСтрокахТабличнойЧасти();
	
КонецПроцедуры //УстановитьНомерГТД()

// Процедура - обработчик команды ОчиститьСтрануПроисхождения
//
&НаКлиенте
Процедура ПеренестиДанныеВДокумент(Команда)
	
	Оповестить("ЗаполнениеНомеровГТД", ЗаписатьПодборВХранилище(), УникальныйИдентификаторФормыВладельца);
	
	Закрыть();
	
КонецПроцедуры // ПеренестиДанныеВДокумент()

// Процедура обработчик вызова подсказки по заполнению номерок ГТД
//
&НаКлиенте
Процедура ДекорацияПодсказкаНажатие(Элемент)
	
	ПараметрыМенеджераПодсказок = Новый Структура("Заголовок, КлючПодсказки", "Как очистить номер ГТД?", "СчетФактураПолученный_ЗаполнениеНомеровГТД");
	
	ОткрытьФорму("Обработка.МенеджерПодсказок.Форма.Форма", ПараметрыМенеджераПодсказок);
	
КонецПроцедуры // ДекорацияПодсказкаНажатие()
