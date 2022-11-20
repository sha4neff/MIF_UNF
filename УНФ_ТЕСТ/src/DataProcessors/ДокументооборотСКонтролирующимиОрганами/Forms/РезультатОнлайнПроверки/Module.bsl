&НаСервере
Перем КонтекстЭДОСервер;

&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	Отчет = Параметры.Отчет;
	Если ТипЗнч(Отчет) = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
		Заголовок = Заголовок + ": " + РегламентированнаяОтчетностьКлиентСервер.ПредставлениеДокументаРеглОтч(Отчет);
	Иначе
		Заголовок = Заголовок + ": " + Строка(Отчет);
	КонецЕсли;
	
	ИмяФайлаВыгрузки = Параметры.ИмяФайлаВыгрузки;
	ТекстВыгрузки = Параметры.ТекстВыгрузки;
	АдресФайлаВыгрузки = "";
	РасширениеФайлаВыгрузки = нрег(КонтекстЭДОСервер.РасширениеФайла(ИмяФайлаВыгрузки));
	ЭтоВыгрузкаДвоичногоФайла = (РасширениеФайлаВыгрузки <> "xml") И (РасширениеФайлаВыгрузки <> "txt") И (РасширениеФайлаВыгрузки <> "htm") И (РасширениеФайлаВыгрузки <> "html") И ЗначениеЗаполнено(РасширениеФайлаВыгрузки);
	
	Если ЭтоАдресВременногоХранилища(ТекстВыгрузки) Тогда
		Содержимое = ПолучитьИзВременногоХранилища(ТекстВыгрузки);
		ТипСодержимого = ТипЗнч(Содержимое);
		Если ТипСодержимого = Тип("ДвоичныеДанные") И НЕ ЭтоВыгрузкаДвоичногоФайла Тогда
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
			Содержимое.Записать(ИмяВременногоФайла);
			Текст = КонтекстЭДОСервер.НовыйЧтениеТекстаНаСервере(ИмяВременногоФайла);
			ТекстСодержимого = Текст.Прочитать();
			ТекстВыгрузки = ТекстСодержимого;
		ИначеЕсли ТипСодержимого = Тип("ХранилищеЗначения") Тогда
			Содержимое = Содержимое.Получить();
			Если НЕ ЭтоВыгрузкаДвоичногоФайла Тогда
				ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
				Содержимое.Записать(ИмяВременногоФайла);
				Текст = КонтекстЭДОСервер.НовыйЧтениеТекстаНаСервере(ИмяВременногоФайла);
				ТекстСодержимого = Текст.Прочитать();
				ТекстВыгрузки = ТекстСодержимого;
			КонецЕсли;
		ИначеЕсли ТипСодержимого = Тип("Строка") Тогда
			// В качестве значения реквизита формы может выступать навигационная ссылка или текст HTML-документа
			ТекстВыгрузки = Содержимое;
			Содержимое = "";
		КонецЕсли;
		Если ЭтоВыгрузкаДвоичногоФайла И ЗначениеЗаполнено(Содержимое) Тогда
			АдресФайлаВыгрузки = ПоместитьВоВременноеХранилище(Содержимое, Новый УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
	Если РасширениеФайлаВыгрузки = "txt" Тогда
		
		ИмяВременногоФайлаВыгрузки = ПолучитьИмяВременногоФайла();
		ОбъектЗаписьТекста = Новый ЗаписьТекста(ИмяВременногоФайлаВыгрузки, "windows-1251");
		ОбъектЗаписьТекста.Записать(ТекстВыгрузки);
		ОбъектЗаписьТекста.Закрыть();
		ОбъектЧтениеТекста = Новый ЧтениеТекста(ИмяВременногоФайлаВыгрузки, "cp866");
		ТекстВыгрузки = ОбъектЧтениеТекста.Прочитать();
		ОбъектЧтениеТекста.Закрыть();
		Попытка
			УдалитьФайлы(ИмяВременногоФайлаВыгрузки);
		Исключение
		КонецПопытки;
		
	КонецЕсли;
	
	ПрограммаПроверки = Параметры.ПрограммаПроверки;
	Если ЗначениеЗаполнено(ПрограммаПроверки) Тогда
		Элементы.ДекорацияПрограммаПроверки.Заголовок = "   " + НСтр("ru = 'Проверено'") + ": " + ПрограммаПроверки;
	КонецЕсли;
	
	ИмяФайлаПротокола = Параметры.ИмяФайлаПротокола;
	
	// в качестве параметров передан адрес во временном хранилище
	Протокол = Параметры.Протокол;
	
	Если ЭтоАдресВременногоХранилища(Протокол) Тогда
		Содержимое = ПолучитьИзВременногоХранилища(Протокол);
		ТипСодержимого = ТипЗнч(Содержимое);
		Если ТипСодержимого = Тип("ДвоичныеДанные") Тогда
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
			Содержимое.Записать(ИмяВременногоФайла);
			Текст = КонтекстЭДОСервер.НовыйЧтениеТекстаНаСервере(ИмяВременногоФайла);
			ТекстСодержимого = Текст.Прочитать();
			Протокол = ТекстСодержимого;
		ИначеЕсли ТипСодержимого = Тип("ХранилищеЗначения") Тогда
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
			Содержимое.Получить().Записать(ИмяВременногоФайла);
			Текст = КонтекстЭДОСервер.НовыйЧтениеТекстаНаСервере(ИмяВременногоФайла);
			ТекстСодержимого = Текст.Прочитать();
			Протокол = ТекстСодержимого;
		ИначеЕсли ТипСодержимого = Тип("Строка") Тогда
			// В качестве значения реквизита формы может выступать навигационная ссылка или текст HTML-документа
			Протокол = Содержимое;
		КонецЕсли;
	КонецЕсли;
	
	РезультатПроверкиВУниверсальномФормате = Параметры.РезультатПроверкиВУниверсальномФормате;
	
	// прорисовываем протокол
	РасширениеФайлаПротокола = нрег(КонтекстЭДОСервер.РасширениеФайла(ИмяФайлаПротокола));
	НачалоПротокола = Лев(Протокол, 8192);
	НачалоПротокола = ВРег(НачалоПротокола);
	ЭтоПротоколHTML = (РасширениеФайлаПротокола = "htm" ИЛИ РасширениеФайлаПротокола = "html")
		И СтрНайти(НачалоПротокола, "<HTML") > 0;
	Если ЭтоПротоколHTML Тогда
		Элементы.ПанельПротокол.ТекущаяСтраница = Элементы.СтраницаHTML;
		ЭлементДекорацияЗаголовкаПротокола = Элементы.ДекорацияЗаголовкаПротоколаHTML;
	Иначе
		Элементы.ПанельПротокол.ТекущаяСтраница = Элементы.СтраницаTXT;
		ЭлементДекорацияЗаголовкаПротокола = Элементы.ДекорацияЗаголовкаПротоколаTXT;
	КонецЕсли;
	
	// Поиск информации о предупреждениях.
	Если СтрНайти(Протокол, "предупрежден") > 0 И (РезультатПроверкиВУниверсальномФормате = 0
		ИЛИ РезультатПроверкиВУниверсальномФормате = "0") Тогда
		РезультатПроверкиВУниверсальномФормате = "4";
	КонецЕсли;
	
	Если РезультатПроверкиВУниверсальномФормате = 0 ИЛИ РезультатПроверкиВУниверсальномФормате = "0" Тогда
		ЭлементДекорацияЗаголовкаПротокола.Заголовок = НСтр("ru = 'Ошибок не обнаружено. Отчет готов к отправке.'");
		ЭлементДекорацияЗаголовкаПротокола.ЦветТекста = Новый Цвет(0, 128, 0);
	ИначеЕсли РезультатПроверкиВУниверсальномФормате = 4 ИЛИ РезультатПроверкиВУниверсальномФормате = "4" Тогда
		ЭлементДекорацияЗаголовкаПротокола.Заголовок = НСтр("ru = 'Есть предупреждения. При необходимости, внесите исправления и повторите попытку.'");
		ЭлементДекорацияЗаголовкаПротокола.ЦветТекста = Новый Цвет(255, 128, 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаРаспечататьПротоколПроверки(Команда)
	
	РасширениеФайлаПротокола = Нрег(КонтекстЭДОКлиент.РасширениеФайла(ИмяФайлаПротокола));
	
	ЭтоПротоколHTML = (РасширениеФайлаПротокола = "htm" ИЛИ РасширениеФайлаПротокола = "html");
	Если ЭтоПротоколHTML Тогда
		Элементы.ПолеHTMLДокументаПротокол.Документ.execCommand("Print");
		
	Иначе
		ТабличныйДокументСТекстомПротокола().Напечатать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСохранитьПротоколПроверки(Команда)
	
	АдресДанных = ПоместитьВоВременноеХранилище(Протокол, Новый УникальныйИдентификатор);
	ИмяФайлаПротоколаПроверкиДляСохранения = ?(ЗначениеЗаполнено(ИмяФайлаПротокола), 
		ИмяФайлаПротокола, НСтр("ru = 'Протокол проверки'") + ".txt");
	
	СохраняемыеФайлы = Новый Структура;
	СохраняемыеФайлы.Вставить("Адрес", 	АдресДанных);
	СохраняемыеФайлы.Вставить("Имя", 	ИмяФайлаПротоколаПроверкиДляСохранения);
	
	ОперацииСФайламиЭДКОКлиент.СохранитьФайлы(СохраняемыеФайлы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДекорацияОткрытьФайлВыгрузкиНажатие(Элемент)
	
	Если ЗначениеЗаполнено(АдресФайлаВыгрузки) Тогда
		ПолучитьФайл(АдресФайлаВыгрузки, ИмяФайлаВыгрузки, Истина);
		
	Иначе
		СтруктураПараметров = Новый Структура("ИмяФайла, Содержимое, ПереноситьПоСловам", ИмяФайлаВыгрузки, ТекстВыгрузки, Истина);
		ОткрытьФорму(КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.ПросмотрТекст", СтруктураПараметров,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаСервере
Функция ТабличныйДокументСТекстомПротокола()
	
	Если КонтекстЭДОСервер = Неопределено Тогда
		КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонецЕсли;
	
	ТабДокумент = Новый ТабличныйДокумент;
	Бланк = КонтекстЭДОСервер.ПолучитьМакет("БланкПечатиТекста");
	
	ТабДокумент.АвтоМасштаб = Истина;
	
	Секция_Тело = Бланк.ПолучитьОбласть("Секция_Тело");
	Для Инд = 1 По СтрЧислоСтрок(Протокол) Цикл
		Секция_Тело.Области["Тело"].Текст = СтрПолучитьСтроку(Протокол, Инд);
		ТабДокумент.Вывести(Секция_Тело);
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

#КонецОбласти