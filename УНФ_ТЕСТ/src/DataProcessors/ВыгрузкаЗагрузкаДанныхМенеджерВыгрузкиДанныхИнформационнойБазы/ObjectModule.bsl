#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущийКонтейнер;
Перем ТекущийОбъектМетаданных; // ОбъектМетаданных - текущий объект метаданных.
Перем ТекущиеОбработчики;
Перем ТекущийПотокЗаписиПересоздаваемыхСсылок;
Перем ТекущийПотокЗаписиСопоставляемыхСсылок;
Перем ТекущийСериализатор;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс


// Инициализирует обработку выгрузки-загрузки данных.
// 
// Параметры:
// 	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - 
// 	ОбъектМетаданных - ОбъектМетаданных -
// 	Обработчики - ТаблицаЗначений - 
// 	Сериализатор - СериализаторXDTO - 
// 	ПотокЗаписиПересоздаваемыхСсылок - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиПересоздаваемыхСсылок - 
// 	ПотокЗаписиСопоставляемыхСсылок - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиСопоставляемыхСсылок - 
//
Процедура Инициализировать(Контейнер, ОбъектМетаданных, Обработчики, Сериализатор, ПотокЗаписиПересоздаваемыхСсылок, ПотокЗаписиСопоставляемыхСсылок) Экспорт
	
	ТекущийКонтейнер = Контейнер;
	ТекущийОбъектМетаданных = ОбъектМетаданных; // ОбъектМетаданных
	ТекущиеОбработчики = Обработчики;
	ТекущийСериализатор = Сериализатор;
	ТекущийПотокЗаписиПересоздаваемыхСсылок = ПотокЗаписиПересоздаваемыхСсылок;
	ТекущийПотокЗаписиСопоставляемыхСсылок = ПотокЗаписиСопоставляемыхСсылок;
  	     
КонецПроцедуры

Процедура ВыгрузитьДанные() Экспорт
	
	Отказ = Ложь;
	ТекущиеОбработчики.ПередВыгрузкойТипа(ТекущийКонтейнер, ТекущийСериализатор, ТекущийОбъектМетаданных, Отказ);
	
	Если Не Отказ Тогда
		ВыгрузитьДанныеОбъектаМетаданных();
	КонецЕсли;
	
	ТекущиеОбработчики.ПослеВыгрузкиТипа(ТекущийКонтейнер, ТекущийСериализатор, ТекущийОбъектМетаданных);
	
КонецПроцедуры

// Выполняет действия для пересоздания ссылки при загрузке.
//
// Параметры:
//	Ссылка - ЛюбаяСсылка - ссылка на объект.
//
Процедура ТребуетсяПересоздатьСсылкуПриЗагрузке(Знач Ссылка) Экспорт
	
	ТекущийПотокЗаписиПересоздаваемыхСсылок.ПересоздатьСсылкуПриЗагрузке(Ссылка);
	
КонецПроцедуры

// Выполняет действия для сопоставления ссылки при загрузке.
//
// Параметры:
//	Ссылка - ЛюбаяСсылка - ссылка на объект.
//	ЕстественныйКлюч - Структура - где ключ, это имя естественного ключа, а значение произвольное значение естественного ключа.
//
Процедура ТребуетсяСопоставитьСсылкуПриЗагрузке(Знач Ссылка, Знач ЕстественныйКлюч) Экспорт
	
	ТекущийПотокЗаписиСопоставляемыхСсылок.СопоставитьСсылкуПриЗагрузке(Ссылка, ЕстественныйКлюч);
	
КонецПроцедуры

Процедура Закрыть() Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыгрузитьДанныеОбъектаМетаданных()
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'ВыгрузкаЗагрузкаДанных.ВыгрузкаОбъектаМетаданных'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,
		ТекущийОбъектМетаданных,
		,
		СтрШаблон(НСтр("ru = 'Начало выгрузки данных объекта метаданных: %1'", ОбщегоНазначения.КодОсновногоЯзыка()),
			ТекущийОбъектМетаданных.ПолноеИмя()));
	
	Если ОбщегоНазначенияБТС.ЭтоКонстанта(ТекущийОбъектМетаданных) Тогда
		
		ВыгрузитьКонстанту();
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ТекущийОбъектМетаданных) Тогда
		
		ВыгрузитьСсылочныйОбъект();
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоНаборЗаписей(ТекущийОбъектМетаданных) Тогда
		
		Если ОбщегоНазначенияБТС.ЭтоНезависимыйНаборЗаписей(ТекущийОбъектМетаданных) Тогда
			
			ВыгрузитьНезависимыйНаборЗаписей();
			
		Иначе
			
			ВыгрузитьНаборЗаписейПодчиненныйРегистратору();
			
		КонецЕсли;
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неожиданный объект метаданных: %1'"),
			ТекущийОбъектМетаданных.ПолноеИмя());
		
	КонецЕсли;
 	
КонецПроцедуры

// Выгружает константу.
//
// Параметры:
//	ПотокЗаписи - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы - поток для записи.
//
Процедура ВыгрузитьКонстанту()
	
	ПотокЗаписи = НачатьЗаписьФайла();
	
	ОбъектМетданныхКонстанта = ТекущийОбъектМетаданных; // ОбъектМетаданных
	МенеджерЗначения = Константы[ОбъектМетданныхКонстанта.Имя].СоздатьМенеджерЗначения();
	МенеджерЗначения.Прочитать();
	ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, МенеджерЗначения);
	
	ЗавершитьЗаписьФайла(ПотокЗаписи);
	
КонецПроцедуры

// Выгружает ссылочный объект.
//
// Параметры:
//	ПотокЗаписи - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиПересоздаваемыхСсылок - поток записи.
//
Процедура ВыгрузитьСсылочныйОбъект()
	
	ПотокЗаписи = НачатьЗаписьФайла();
	
	ИмяОбъекта = ТекущийОбъектМетаданных.ПолноеИмя(); // Строка
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОбъекта);
	
	Выборка = МенеджерОбъекта.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ПотокЗаписи.РазмерБольшеРекомендуемого() Тогда
			ЗавершитьЗаписьФайла(ПотокЗаписи);
			ПотокЗаписи = НачатьЗаписьФайла();
		КонецЕсли;
		
		Объект = Выборка.ПолучитьОбъект();
		ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, Объект);
		
	КонецЦикла;
	
	ЗавершитьЗаписьФайла(ПотокЗаписи);
	
КонецПроцедуры

// Выгружает независимый набор записей, с помощью курсорного (постраничного) запроса.
//
// Параметры:
//	ПотокЗаписи - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы - поток для записи. 
//
Процедура ВыгрузитьНезависимыйНаборЗаписей()
	
	Состояние = Неопределено;
	Отбор = Новый Массив;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекущийОбъектМетаданных.ПолноеИмя());
	
	ПоляСДвоичнымиДанными = Новый Массив;
	Для Каждого Поле Из ТекущийОбъектМетаданных.Ресурсы Цикл
		Если Поле.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
			ПоляСДвоичнымиДанными.Добавить(Поле.Имя);
		КонецЕсли;
	КонецЦикла;
	Для Каждого Поле Из ТекущийОбъектМетаданных.Реквизиты Цикл
		Если Поле.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
			ПоляСДвоичнымиДанными.Добавить(Поле.Имя);
		КонецЕсли;
	КонецЦикла;
	
	ПотокЗаписи = НачатьЗаписьФайла();
	
	Если ПоляСДвоичнымиДанными.Количество() = 0 Тогда
		
		Пока Истина Цикл
			
			Если ПотокЗаписи.РазмерБольшеРекомендуемого() Тогда
				ЗавершитьЗаписьФайла(ПотокЗаписи);
				ПотокЗаписи = НачатьЗаписьФайла();
			КонецЕсли;
			
			МассивТаблиц = ТехнологияСервисаСлужебныйЗапросы.ПолучитьПорциюДанныхНезависимогоНабораЗаписей(
				ТекущийОбъектМетаданных, Отбор, 10000, Ложь, Состояние);
			
			Если МассивТаблиц.Количество() = 0 Тогда
				Прервать;
			КонецЕсли;
			
			НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей();
			
			Для Каждого Таблица Из МассивТаблиц Цикл
				
				Для Каждого Строка Из Таблица Цикл
					
					Запись = НаборЗаписей.Добавить();
					ЗаполнитьЗначенияСвойств(Запись, Строка);
					
				КонецЦикла;
				
			КонецЦикла;
			
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
			
		КонецЦикла;
		
	Иначе
		
		МаксимальныйРазмер = 100 * 1024 * 1024; // 100 Мб
		РазмерНабора = 0;
		НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей();
		Выборка = МенеджерОбъекта.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			РазмерЗаписи = 0;
			Для Каждого Поле Из ПоляСДвоичнымиДанными Цикл
				ХранилищеЗначения = Выборка[Поле];
				Если ТипЗнч(ХранилищеЗначения) <> Тип("ХранилищеЗначения") Тогда
					Продолжить;
				КонецЕсли;
				Попытка
					Данные = ХранилищеЗначения.Получить();
				Исключение
					Данные = Неопределено;
				КонецПопытки;
				Если ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда
					РазмерЗаписи = РазмерЗаписи + Данные.Размер();
				Иначе
					РазмерЗаписи = РазмерЗаписи + СтрДлина(XMLСтрока(ХранилищеЗначения)) * 2;
				КонецЕсли;
			КонецЦикла;
			
			Если (РазмерНабора + РазмерЗаписи) > МаксимальныйРазмер Или НаборЗаписей.Количество() = 10000 Тогда
				ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
				ЗавершитьЗаписьФайла(ПотокЗаписи);
				ПотокЗаписи = НачатьЗаписьФайла();
				РазмерНабора = 0;
				НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей();
			КонецЕсли;
			
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, Выборка);
			РазмерНабора = РазмерНабора + РазмерЗаписи;
			
		КонецЦикла;
		
		Если НаборЗаписей.Количество() Тогда
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
		КонецЕсли;
		
	КонецЕсли;
	
	ЗавершитьЗаписьФайла(ПотокЗаписи);
	
КонецПроцедуры

// Выгружает набор записей, подчиненный регистратору.
//
// Параметры:
//	ПотокЗаписи - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы - поток для записи.
//
Процедура ВыгрузитьНаборЗаписейПодчиненныйРегистратору()
	
	Если ОбщегоНазначенияБТС.ЭтоНаборЗаписейПерерасчета(ТекущийОбъектМетаданных) Тогда
		
		ИмяПоляРегистратора = "ОбъектПерерасчета";
		
		Подстроки = СтрРазделить(ТекущийОбъектМетаданных.ПолноеИмя(), ".");
		ИмяТаблицы = Подстроки[0] + "." + Подстроки[1] + "." + Подстроки[3];
		
	Иначе
		
		ИмяПоляРегистратора = "Регистратор";
		ИмяТаблицы = ТекущийОбъектМетаданных.ПолноеИмя();
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	_XMLВыгрузка_Таблица." + ИмяПоляРегистратора + " КАК Регистратор
	|ИЗ
	|	" + ИмяТаблицы + " КАК _XMLВыгрузка_Таблица";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекущийОбъектМетаданных.ПолноеИмя());
	
	ПотокЗаписи = НачатьЗаписьФайла();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ПотокЗаписи.РазмерБольшеРекомендуемого() Тогда
			ЗавершитьЗаписьФайла(ПотокЗаписи);
			ПотокЗаписи = НачатьЗаписьФайла();
		КонецЕсли;
		
		НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей();
		ЭлементОтбора = НаборЗаписей.Отбор[ИмяПоляРегистратора]; // ЭлементОтбора
		ЭлементОтбора.Установить(Выборка.Регистратор);
		
		НаборЗаписей.Прочитать();
		
		ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
		
	КонецЦикла;
	
	ЗавершитьЗаписьФайла(ПотокЗаписи);
	
КонецПроцедуры

// Записывает объект в XML.
//
// Параметры:
//	ПотокЗаписи - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы - поток для записи. 
//	Данные - Произвольный - записываемый объект.
//
Процедура ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, Данные)
	
	Отказ = Ложь;
	Артефакты = Новый Массив();
	ТекущиеОбработчики.ПередВыгрузкойОбъекта(ТекущийКонтейнер, ЭтотОбъект, ТекущийСериализатор, Данные, Артефакты, Отказ);
	
	Если Не Отказ Тогда
		ПотокЗаписи.ЗаписатьОбъектДанныхИнформационнойБазы(Данные, Артефакты);
	КонецЕсли;
	
	ТекущиеОбработчики.ПослеВыгрузкиОбъекта(ТекущийКонтейнер, ЭтотОбъект, ТекущийСериализатор, Данные, Артефакты);
	
КонецПроцедуры

Функция НачатьЗаписьФайла()
	
	ИмяФайла = ТекущийКонтейнер.СоздатьФайл(
		ВыгрузкаЗагрузкаДанныхСлужебный.InfobaseData(), ТекущийОбъектМетаданных.ПолноеИмя());
	
	ПотокЗаписи = Обработки.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы.Создать();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла, ТекущийСериализатор);
	
	Возврат ПотокЗаписи;
	
КонецФункции

Процедура ЗавершитьЗаписьФайла(ПотокЗаписи)
	
	ПотокЗаписи.Закрыть();
	
	КоличествоОбъектов = ПотокЗаписи.КоличествоОбъектов();
	Если КоличествоОбъектов = 0 Тогда
		ТекущийКонтейнер.ИсключитьФайл(ПотокЗаписи.ИмяФайла());
	Иначе
		ТекущийКонтейнер.УстановитьКоличествоОбъектов(ПотокЗаписи.ИмяФайла(), КоличествоОбъектов);
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'ВыгрузкаЗагрузкаДанных.ВыгрузкаОбъектаМетаданных'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,
		ТекущийОбъектМетаданных,
		,
		СтрШаблон(НСтр("ru = 'Окончание выгрузки данных объекта метаданных: %1
		|Выгружено объектов: %2'", ОбщегоНазначения.КодОсновногоЯзыка()),
			ТекущийОбъектМетаданных.ПолноеИмя(), КоличествоОбъектов));
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
