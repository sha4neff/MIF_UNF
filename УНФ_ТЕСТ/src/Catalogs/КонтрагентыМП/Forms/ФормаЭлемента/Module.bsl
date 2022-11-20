#Область ОписаниеПеременных

&НаКлиенте
Перем КэшНайденныхКонтактов;

#КонецОбласти

#Область ОбщегоНазначения

&НаКлиенте
Процедура ПозвонитьОтправитьСМС(Схема)
	
	#Если МобильноеПриложениеКлиент Тогда
		
		Если ЗначениеЗаполнено(Объект.НомерТелефона) Тогда
			// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
			ЗапуститьПриложение(Схема + СокрЛП(Объект.НомерТелефона));
			// АПК:534-вкл
		Иначе
			ПоказатьПредупреждение(Неопределено, НСтр("ru='Вначале укажите телефон.';en='First, specify the telephone.'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
		КонецЕсли
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗапускаПриложения(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	Возврат; // Процедура заглушка, т.к. НачатьЗапускПриложения требуется наличие обработчика оповещения.
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики
	
	Баланс = РегистрыНакопления.ВзаиморасчетыСКонтрагентамиМП.ПолучитьОстатокВзаиморасчетовСКонтрагентом(Объект.Ссылка);
	Если Баланс > 0 Тогда
		Элементы.Баланс.Заголовок = НСтр("ru='Долг нам';en='Debt us'");
	ИначеЕсли Баланс < 0 Тогда
		Баланс = - Баланс;
		Элементы.Баланс.Заголовок = НСтр("ru='Наш долг';en='Our duty'");
	Иначе
		Элементы.Баланс.Заголовок = НСтр("ru='Долгов нет';en='No debt'");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда // Баланс не должен быть видим для нового объекта.
		Элементы.ГруппаБаланс.Видимость = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияМПСервер.УстановитьЗаголовокФормы(ЭтаФорма, НСтр("en='Customer / Supplier';ru='Контрагент'"));
	
	// Меняем оформление под веб клиент
	#Если НЕ МобильноеПриложениеСервер Тогда
		Элементы.ФормаГруппа1.Видимость = Ложь;
		Элементы.ФормаГруппа2.Видимость = Ложь;
		Элементы.Позвонить.Видимость = Ложь;
		Элементы.ОтправитьСМС.Видимость = Ложь;
		Элементы.Баланс.РастягиватьПоГоризонтали = Ложь;
		Элементы.Адрес.АвтоМаксимальнаяВысота = Истина;
		Элементы.Адрес.АвтоМаксимальнаяШирина = Истина;
		Элементы.Наименование.Ширина = 40;
		Элементы.Адрес.Ширина = 40;
		ЭтаФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	#Если НЕ МобильноеПриложениеСервер Тогда
		Если ВРег(Метаданные.Имя) = ВРег("УправлениеНебольшойФирмойНаМобильном") Тогда
			Возврат;
		КонецЕсли;
		// АПК:488-выкл методы безопасного запуска обеспечиваются этой функцией
		МодульСинхронизацияПушУведомленияМПУНФ = Вычислить("СинхронизацияПушУведомленияМПУНФ");
		// АПК:488-вкл
		Если ТипЗнч(МодульСинхронизацияПушУведомленияМПУНФ) = Тип("ОбщийМодуль") Тогда
			МодульСинхронизацияПушУведомленияМПУНФ.ОтправитьПушУведомление("001");
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ДействияКомандныхПанелейФормы

&НаКлиенте
Процедура Позвонить(Команда)
	
	#Если МобильноеПриложениеКлиент Тогда
		
		// Сбор статистики
		СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
		// Конец Сбор статистики
		
		ПозвонитьОтправитьСМС("tel:");
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСМС(Команда)
	
	#Если МобильноеПриложениеКлиент Тогда
		
		// Сбор статистики
		СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
		// Конец Сбор статистики
		
		ПозвонитьОтправитьСМС("sms:");
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЭлектронноеПисьмо(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	Если ЗначениеЗаполнено(Объект.АдресЭП) Тогда
		НачатьЗапускПриложения(Новый ОписаниеОповещения("ПослеЗапускаПриложения", ЭтотОбъект), "mailto:" + СокрЛП(Объект.АдресЭП));
	Иначе
		ПоказатьПредупреждение(, НСтр("ru='Вначале укажите Email!';en='First, specify the Email!'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	#Если МобильноеПриложениеКлиент Тогда
		// АПК:488-выкл методы безопасного запуска обеспечиваются этой функцией
		МодульМенеджерКонтактовКлиент = Вычислить("МенеджерКонтактовКлиент");
		// АПК:488-вкл
		Если ТипЗнч(МодульМенеджерКонтактовКлиент) = Тип("ОбщийМодуль") Тогда
			
			МодульМенеджерКонтактовКлиент.ЗаполнитьСписокВыбораИзКонтактнойКниги(
			Текст,
			ДанныеВыбора,
			СтандартнаяОбработка,
			КэшНайденныхКонтактов,
			Ложь
			);
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	#Если МобильноеПриложениеКлиент Тогда
		ИспользоватьСинхронизациюСКонтактнойКнигой = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ИспользоватьСинхронизациюСКонтактнойКнигой");
		Если НЕ ИспользоватьСинхронизациюСКонтактнойКнигой Тогда
			Возврат;
		КонецЕсли;
		
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
			СтандартнаяОбработка = Ложь;
			МенеджерКонтактовКлиент.ЗаполнитьРеквизитыКонтрагента(Объект, ВыбранноеЗначение);
		КонецЕсли;
		КэшНайденныхКонтактов = Неопределено;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНаКартеКоманда(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	#Если МобильноеПриложениеКлиент Тогда
		Если ОбщегоНазначенияМПВызовСервера.ВерсияОС() = "iOS" Тогда
			// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
			ПерейтиПоНавигационнойСсылке("http://maps.apple.com/?q=" + ОбщегоНазначенияМПВызовСервера.Кодировать(Объект.Адрес));
			// АПК:534-вкл
		Иначе
			Запуск = Новый ЗапускПриложенияМобильногоУстройства();
			Запуск.Действие = "android.intent.action.VIEW";
			Запуск.Данные = "geo:0,0?q=" + Объект.Адрес;
			Запуск.Запустить(Ложь);
		КонецЕсли;
	#Иначе
		// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
		ПерейтиПоНавигационнойСсылке("https://maps.yandex.ru/?text=" + Объект.Адрес);
		// АПК:534-вкл
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбщегоНазначенияМПСервер.УстановитьЗаголовокФормы(ЭтаФорма, НСтр("en='Customer / Supplier';ru='Контрагент'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Справка(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	ПерейтиПоНавигационнойСсылке("https://sbm.1c.ru/about/razdel-kontragenty/-rekvizity-kontregenta/");
	// АПК:534-вкл
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
КонецПроцедуры

#КонецОбласти
