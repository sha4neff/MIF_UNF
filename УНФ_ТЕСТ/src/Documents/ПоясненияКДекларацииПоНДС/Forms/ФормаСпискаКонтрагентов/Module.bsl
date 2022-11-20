&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.ЗаголовокФормы;
	
	Для Каждого Контрагент Из Параметры.Контрагенты Цикл
		ЗаполнитьЗначенияСвойств(Контрагенты.Добавить(), Контрагент.Значение);
	КонецЦикла;
	
	Если ТолькоПросмотр Тогда
		Элементы.Контрагенты.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
		Элементы.ФормаКомандаОК.Видимость = Ложь;
	КонецЕсли;
	
	РеквизитыКонтрагентов = Документы.ПоясненияКДекларацииПоНДС.РеквизитыКонтрагентов();
	
	ЗаполнитьКонтрагентов();
	
	УстановитьВозможностьВыбораКонтрагентов();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда 
		
		Если НЕ ПеренестиВДокумент Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Отменить изменения?'");
	
			ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
				ЭтотОбъект, 
				Отказ, 
				ЗавершениеРаботы,
				ТекстПредупреждения, 
				"ПеренестиВДокумент");
			
		ИначеЕсли Не Отказ Тогда
				
			Отказ = НЕ ПроверитьЗаполнениеНаКлиенте();
			Если Отказ Тогда
				ПеренестиВДокумент = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура КонтрагентыИННПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.Контрагенты.ТекущиеДанные;
	
	Сведения = СведенияОКонтрагентеПоИНН(ДанныеСтроки.ИНН);
	
	УстановитьСведенияОКонтрагентеРеквизита(ДанныеСтроки, Сведения);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентыИНННачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеСтроки = Элементы.Контрагенты.ТекущиеДанные;
	
	ВыбратьКонтрагента(ДанныеСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Если ПроверитьЗаполнениеНаКлиенте() Тогда 
		РезультатЗакрытия = СписокКонтрагентов();
		ОповеститьОВыборе(РезультатЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	ПеренестиВДокумент = Ложь;
	Модифицированность = Ложь;
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	ДобавитьОформляемоеПоле(ЭлементУО.Поля, "КонтрагентыИНН");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Контрагенты.КоличествоКонтрагентов", ВидСравненияКомпоновкиДанных.Больше, 0);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Контрагенты.ПредставлениеКонтрагента"));
	
КонецПроцедуры

&НаСервере
Функция ДобавитьОформляемоеПоле(КоллекцияОформляемыхПолей, ИмяПоля) Экспорт
	
	ПолеЭлемента 		= КоллекцияОформляемыхПолей.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных(ИмяПоля);
	
	Возврат ПолеЭлемента;
	
КонецФункции

&НаКлиенте
Функция СписокКонтрагентов()
	
	СписокКонтрагентов = Новый СписокЗначений();
	
	Для Каждого Контрагент Из Контрагенты Цикл
		ЗначенияРеквизитов = Новый Структура(РеквизитыКонтрагентов);
		ЗаполнитьЗначенияСвойств(ЗначенияРеквизитов, Контрагент);
		ЗначенияРеквизитов.Вставить("Контрагенты", Контрагент.Контрагенты);
		СписокКонтрагентов.Добавить(ЗначенияРеквизитов, Контрагент.ПредставлениеКонтрагента);
	КонецЦикла;
	
	Возврат СписокКонтрагентов;
	
КонецФункции

&НаКлиенте
Функция ПроверитьЗаполнениеНаКлиенте()
	
	Отказ = Ложь;
	
	Для Каждого Контрагент Из Контрагенты Цикл
		Если НЕ ЗначениеЗаполнено(Контрагент.ИНН) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'ИНН'"));
			Поле = "Контрагенты["+ Формат(Контрагенты.Индекс(Контрагент), "ЧДЦ=; ЧГ=0") +"].ИНН";
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		ИначеЕсли НЕ (СтрДлина(Контрагент.ИНН) = 10 ИЛИ СтрДлина(Контрагент.ИНН) = 12) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Корректность", НСтр("ru = 'ИНН'"), , , НСтр("ru = 'Длина ИНН должна быть 10 или 12 символов'"));
			Поле = "Контрагенты["+ Формат(Контрагенты.Индекс(Контрагент), "ЧДЦ=; ЧГ=0") +"].ИНН";
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Не Отказ;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКонтрагентов()
	
	ТаблицаИНН = Контрагенты.Выгрузить(, "ИНН");
	
	ТаблицаКонтрагентов = Документы.ПоясненияКДекларацииПоНДС.КонтрагентыПоСпискуИНН(ТаблицаИНН);
	
	Для Каждого Контрагент Из Контрагенты Цикл
		
		Сведения = Документы.ПоясненияКДекларацииПоНДС.СведенияОКонтрагентеПоТаблицеКонтрагентов(Контрагент.ИНН, ТаблицаКонтрагентов);
		УстановитьСведенияОКонтрагентеРеквизита(Контрагент, Сведения);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКонтрагента(ДанныеСтроки)
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	Если ДанныеСтроки.Контрагенты.Количество()>0 Тогда
		ПараметрыФормы.Вставить("ТекущаяСтрока", ДанныеСтроки.Контрагенты[0].Значение);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("ИдентификаторСтроки", ДанныеСтроки.ПолучитьИдентификатор());
	
	ОповещениеФормы = Новый ОписаниеОповещения("ВыбратьКонтрагентаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ПараметрыФормы, ЭтотОбъект, , , , ОповещениеФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКонтрагентаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		
		ДанныеСтроки = Контрагенты.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
		Если ДанныеСтроки = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Модифицированность = Истина;
		
		Сведения = СведенияОКонтрагентеПоСсылке(РезультатЗакрытия);
		
		УстановитьСведенияОКонтрагентеРеквизита(ДанныеСтроки, Сведения);
		
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СведенияОКонтрагентеПоСсылке(Контрагент)
	
	Возврат Документы.ПоясненияКДекларацииПоНДС.СведенияОКонтрагентеПоСсылке(Контрагент);
	
КонецФункции

&НаСервереБезКонтекста
Функция СведенияОКонтрагентеПоИНН(ИНН)
	
	Возврат Документы.ПоясненияКДекларацииПоНДС.СведенияОКонтрагентеПоИНН(ИНН);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСведенияОКонтрагентеРеквизита(ДанныеСтроки, Сведения)
	
	ДанныеСтроки.ИНН = Сведения.ИНН;
	ДанныеСтроки.ПредставлениеКонтрагента = Сведения.Представление;
	ДанныеСтроки.Контрагенты =Сведения.Контрагенты;
	ДанныеСтроки.КоличествоКонтрагентов =Сведения.Контрагенты.Количество();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВозможностьВыбораКонтрагентов()
	
	КонтрагентыДоступны = ЭлектронныйДокументооборотСКонтролирующимиОрганами.СправочникКонтрагентовДоступен();
	
	Если НЕ КонтрагентыДоступны Тогда
		Элементы.КонтрагентыИНН.КнопкаВыбора = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ТекущиеДанные = Элементы.Контрагенты.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		КонтрагентыИзСтроки = ТекущиеДанные.Контрагенты;
		КонтекстЭДОКлиент.ОткрытьКонтрагентовИзТребования(КонтрагентыИзСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти