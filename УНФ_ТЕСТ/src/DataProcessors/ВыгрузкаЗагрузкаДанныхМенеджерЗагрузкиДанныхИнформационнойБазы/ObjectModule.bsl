#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущийКонтейнер;
Перем ТекущиеЗагружаемыеТипы;
Перем ТекущиеИсключаемыеТипы;
Перем ТекущиеОбработчики;
Перем ТекущийПотокЗаменыСсылок;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура Инициализировать(Контейнер, ЗагружаемыеТипы, ИсключаемыеТипы, Обработчики) Экспорт
	
	ТекущийКонтейнер = Контейнер;
	ТекущиеЗагружаемыеТипы = ЗагружаемыеТипы;
	ТекущиеЗагружаемыеТипы = СортироватьЗагружаемыеТипы(ТекущиеЗагружаемыеТипы);
	ТекущиеИсключаемыеТипы = ИсключаемыеТипы;
	ТекущиеОбработчики = Обработчики;
	ТекущийПотокЗаменыСсылок = Обработки.ВыгрузкаЗагрузкаДанныхПотокЗаменыСсылок.Создать();
	ТекущийПотокЗаменыСсылок.Инициализировать(ТекущийКонтейнер, ТекущиеОбработчики);
	
КонецПроцедуры

Процедура ЗагрузитьДанные() Экспорт
	
	ВыполнитьЗаменуСсылок();
	ВыполнитьЗагрузкуДанных();
	
КонецПроцедуры

Функция ТекущийПотокЗаменыСсылок() Экспорт
	
	Возврат ТекущийПотокЗаменыСсылок;
	
КонецФункции

//@skip-warning
Процедура Закрыть() Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Типы сортируются по убыванию приоритета, сериализаторы выбирают их из массива с конца.
//
// Параметры:
//	ЗагружаемыеТипы - Массив из ОбъектМетаданных - массив метаданных.
//
// Возвращаемое значение:
//	Массив - отсортированный массив метаданных по приоритету.
//
Функция СортироватьЗагружаемыеТипы(Знач ЗагружаемыеТипы)
	
	Сортировка = Новый ТаблицаЗначений();
	Сортировка.Колонки.Добавить("ОбъектМетаданных");
	Сортировка.Колонки.Добавить("Приоритет", Новый ОписаниеТипов("Число"));
	
	Для каждого ОбъектМетаданных Из ЗагружаемыеТипы Цикл
		
		Строка = Сортировка.Добавить();
		Строка.ОбъектМетаданных = ОбъектМетаданных;
		
		Если ОбщегоНазначенияБТС.ЭтоКонстанта(ОбъектМетаданных) Тогда
			
			Строка.Приоритет = 0;
			
		ИначеЕсли ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда
			
			Если ОбщегоНазначенияБТС.ЭтоПланВидовХарактеристик(ОбъектМетаданных) Тогда
				
				Строка.Приоритет = 1;
				
			ИначеЕсли ОбщегоНазначенияБТС.ЭтоПланСчетов(ОбъектМетаданных) Тогда
				
				Строка.Приоритет = 2;
				
			ИначеЕсли ОбщегоНазначенияБТС.ЭтоПланВидовРасчета(ОбъектМетаданных) Тогда
				
				Строка.Приоритет = 3;
				
			ИначеЕсли ОбщегоНазначенияБТС.ЭтоСправочник(ОбъектМетаданных) Тогда
				
				Строка.Приоритет = 4;
				
			Иначе
				
				Строка.Приоритет = 5;
				
			КонецЕсли;
				
		ИначеЕсли ОбщегоНазначенияБТС.ЭтоНаборЗаписей(ОбъектМетаданных) Тогда
			
			Строка.Приоритет = 6;
			
		ИначеЕсли Метаданные.РегистрыРасчета.Содержит(ОбъектМетаданных.Родитель()) Тогда // Перерасчеты
			
			Строка.Приоритет = 7;
			
		ИначеЕсли Метаданные.Последовательности.Содержит(ОбъектМетаданных) Тогда
			
			Строка.Приоритет = 8;
			
		Иначе
			
			ШаблонТекста = НСтр("ru = 'Выгрузка объекта метаданных не поддерживается %1'");
			ТекстСообщения = СтрШаблон(ШаблонТекста, ОбъектМетаданных.ПолноеИмя());
			ВызватьИсключение(ТекстСообщения);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Сортировка.Сортировать("Приоритет");
	
	Возврат Сортировка.ВыгрузитьКолонку("ОбъектМетаданных");
	
КонецФункции

Процедура ВыполнитьЗаменуСсылок()
	
	МенеджерПересозданияСсылок = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерПересозданияСсылок.Создать();
	МенеджерПересозданияСсылок.Инициализировать(ТекущийКонтейнер, ТекущийПотокЗаменыСсылок);
	МенеджерПересозданияСсылок.ВыполнитьПересозданиеСсылок();
	
	МенеджерСопоставленияСсылок = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерСопоставленияСсылок.Создать();
	МенеджерСопоставленияСсылок.Инициализировать(ТекущийКонтейнер, ТекущийПотокЗаменыСсылок, ТекущиеОбработчики);
	МенеджерСопоставленияСсылок.ВыполнитьСопоставлениеСсылок();
	
КонецПроцедуры

Процедура ВыполнитьЗагрузкуДанных()
	
	Для Каждого ОбъектМетаданных Из ТекущиеЗагружаемыеТипы Цикл
		
		Если ТекущиеИсключаемыеТипы.Найти(ОбъектМетаданных) = Неопределено Тогда
			
			Отказ = Ложь;
			ТекущиеОбработчики.ПередЗагрузкойТипа(ТекущийКонтейнер, ОбъектМетаданных, Отказ);
			
			Если Не Отказ Тогда
				ЗагрузитьДанныеОбъектаИнформационнойБазы(ОбъектМетаданных);
			КонецЕсли;
			
			ТекущиеОбработчики.ПослеЗагрузкиТипа(ТекущийКонтейнер, ОбъектМетаданных);
			
		Иначе
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'ВыгрузкаЗагрузкаДанных.ЗагрузкаОбъектаПропущена'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Информация,
				ОбъектМетаданных,
				,
				СтрШаблон(НСтр("ru = 'Загрузка данных объекта метаданных %1 пропущена, т.к. он включен в
                          |список объектов метаданных, исключаемых из выгрузки и загрузки данных'", ОбщегоНазначения.КодОсновногоЯзыка()),
					ОбъектМетаданных.ПолноеИмя()));
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Загружает все необходимые данные для объекта информационной базы.
//
// Параметры:
//	ОбъектМетаданных - ОбъектМетаданных - загружаемый объект метаданных.
//
Процедура ЗагрузитьДанныеОбъектаИнформационнойБазы(Знач ОбъектМетаданных)
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'ВыгрузкаЗагрузкаДанных.ЗагрузкаОбъектаМетаданных'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,
		ОбъектМетаданных,
		,
		СтрШаблон(НСтр("ru = 'Начало загрузки данных объекта метаданных: %1'", ОбщегоНазначения.КодОсновногоЯзыка()),
			ОбъектМетаданных.ПолноеИмя()));
	
	Для Каждого ОписаниеФайла Из ТекущийКонтейнер.ПолучитьОписанияФайловИзКаталога(ВыгрузкаЗагрузкаДанныхСлужебный.InfobaseData(), ОбъектМетаданных.ПолноеИмя()) Цикл
		
		ТекущийКонтейнер.РаспаковатьФайл(ОписаниеФайла);
		
		ТекущийПотокЗаменыСсылок.ВыполнитьЗаменуСсылокВФайле(ОписаниеФайла);
		
		ПотокЧтения = Обработки.ВыгрузкаЗагрузкаДанныхПотокЧтенияДанныхИнформационнойБазы.Создать();
		ПотокЧтения.ОткрытьФайл(ОписаниеФайла.ПолноеИмя);

		КоличествоОбъектов = 0;
		
		Пока ПотокЧтения.ПрочитатьОбъектДанныхИнформационнойБазы() Цикл
			
			Объект = ПотокЧтения.ТекущийОбъект();
			Артефакты = ПотокЧтения.АртефактыТекущегоОбъекта();
			
			ЗаписатьОбъектВИнформационнуюБазу(Объект, Артефакты);
			
			КоличествоОбъектов = КоличествоОбъектов + 1;
			
		КонецЦикла;
		
		ПотокЧтения.Закрыть();
		УдалитьФайлы(ОписаниеФайла.ПолноеИмя);
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'ВыгрузкаЗагрузкаДанных.ЗагрузкаОбъектаМетаданных'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация,
			ОбъектМетаданных,
			,
			СтрШаблон(НСтр("ru = 'Окончание загрузки данных объекта метаданных: %1
			|Загружено объектов: %2'", ОбщегоНазначения.КодОсновногоЯзыка()),
				ОбъектМетаданных.ПолноеИмя(), КоличествоОбъектов));
				
	КонецЦикла;
	
КонецПроцедуры

// Записывает объект в информационную базу.
//
// Параметры:
//	Объект - Произвольный - загружаемый объект метаданных.
//	АртефактыОбъекта - Массив из ОбъектXDTO - массив объектов XDTO.
//
Процедура ЗаписатьОбъектВИнформационнуюБазу(Объект, АртефактыОбъекта)
	
	Отказ = Ложь;
	ТекущиеОбработчики.ПередЗагрузкойОбъекта(ТекущийКонтейнер, Объект, АртефактыОбъекта, Отказ);
	МетаданныеОбъекта = Объект.Метаданные(); // ОбъектМетаданных
	
	Если Не Отказ Тогда
		
		Если ОбщегоНазначенияБТС.ЭтоКонстанта(МетаданныеОбъекта) Тогда
			
			Если Не ЗначениеЗаполнено(Объект.Значение) Тогда
				// Поскольку константы предварительно очищались - повторная перезапись пустых
				// значений не требуется.
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		Объект.ОбменДанными.Загрузка = Истина;
		Объект.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		
		Если ОбщегоНазначенияБТС.ЭтоНезависимыйНаборЗаписей(МетаданныеОбъекта) Тогда
			
			Попытка
				
				// Т.к. независимые наборы записей выгружаются курсорными запросами - запись
				// выполняется без замещения.
				Объект.Записать(Ложь);
				
			Исключение
				
				Комментарий = СтрШаблон(НСтр("ru = 'Объекта метаданных %1 с представлением ""%2"" не загружен по причине: %3'", ОбщегоНазначения.КодОсновногоЯзыка()),
				                        МетаданныеОбъекта.ПолноеИмя(),
				                        Строка(Объект),
				                        ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'ВыгрузкаЗагрузкаДанных.ЗагрузкаОбъектаМетаданных.Ошибка'", ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					МетаданныеОбъекта,
					,
					Комментарий);
						
				ВызватьИсключение Комментарий;
				
			КонецПопытки;
			
		Иначе
			
			Попытка		
				
				Объект.Записать();
				
			Исключение
				
				Комментарий = СтрШаблон(НСтр("ru = 'Объекта метаданных %1 с представлением ""%2"" не загружен по причине: %3'", ОбщегоНазначения.КодОсновногоЯзыка()),
				                        МетаданныеОбъекта.ПолноеИмя(),
				                        Строка(Объект),
				                        ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'ВыгрузкаЗагрузкаДанных.ЗагрузкаОбъектаМетаданных.Ошибка'", ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					МетаданныеОбъекта,
					,
					Комментарий);
			
				ВызватьИсключение Комментарий;
				
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТекущиеОбработчики.ПослеЗагрузкиОбъекта(ТекущийКонтейнер, Объект, АртефактыОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
