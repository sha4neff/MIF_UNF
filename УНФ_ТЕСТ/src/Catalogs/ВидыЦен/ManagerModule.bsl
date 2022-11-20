#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйИнтерфейс

Процедура ПодготовитьТаблицуРегистраЗависимыеВидыЦен(ТаблицаЗависимыхЦен, ЭтотОбъект)
	
	Если ТаблицаЗависимыхЦен = Неопределено Тогда
		
		ТаблицаЗависимыхЦен = Новый ТаблицаЗначений;
		ТаблицаЗависимыхЦен.Колонки.Добавить("ВидЦенРасчетный");
		ТаблицаЗависимыхЦен.Колонки.Добавить("ВидЦенБазовый");
		ТаблицаЗависимыхЦен.Колонки.Добавить("ЦеноваяГруппа");
		ТаблицаЗависимыхЦен.Колонки.Добавить("ВидЦенБазовыйЦеновойГруппы");
		
	КонецЕсли;
	
	Если ЭтотОбъект.ТипВидаЦен = Перечисления.ТипыВидовЦен.ДинамическийФормула Тогда
		
		ОтборСтрок = Новый Структура("ВидЦенРасчетный, ВидЦенБазовый, ЦеноваяГруппа");
		
		Операнды = ЦенообразованиеФормулыСервер.ПолучитьТаблицуОперандовФормулы(ТекущаяДатаСеанса(), ЭтотОбъект.Формула);
		Для каждого Операнд Из Операнды Цикл
			
			Если НЕ ЗначениеЗаполнено(Операнд.ВидЦен)
				ИЛИ ТаблицаЗависимыхЦен.Найти(Операнд.ВидЦен, "ВидЦенБазовый") <> Неопределено Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			НоваяСтрока								= ТаблицаЗависимыхЦен.Добавить();
			НоваяСтрока.ВидЦенРасчетный				= ЭтотОбъект.Ссылка;
			НоваяСтрока.ВидЦенБазовый				= Операнд.ВидЦен;
			НоваяСтрока.ЦеноваяГруппа				= Неопределено;
			НоваяСтрока.ВидЦенБазовыйЦеновойГруппы	= Неопределено;
			
		КонецЦикла;
		
		Для каждого СтрокаТаблицы Из ЭтотОбъект.ЦеновыеГруппы Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ЦеноваяГруппа) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			Операнды = ЦенообразованиеФормулыСервер.ПолучитьТаблицуОперандовФормулы(ТекущаяДатаСеанса(), СтрокаТаблицы.Формула);
			Для каждого Операнд Из Операнды Цикл
				
				Если НЕ ЗначениеЗаполнено(Операнд.ВидЦен) Тогда
					
					Продолжить;
					
				КонецЕсли;
				
				ОтборСтрок.ВидЦенБазовый = Операнд.ВидЦен;
				ОтборСтрок.ЦеноваяГруппа = СтрокаТаблицы.ЦеноваяГруппа;
				
				МассивСтрок = ТаблицаЗависимыхЦен.НайтиСтроки(ОтборСтрок);
				Если МассивСтрок.Количество() > 0 Тогда
					
					Продолжить;
					
				КонецЕсли;
				
				НоваяСтрока								= ТаблицаЗависимыхЦен.Добавить();
				НоваяСтрока.ВидЦенРасчетный				= ЭтотОбъект.Ссылка;
				НоваяСтрока.ВидЦенБазовый				= Неопределено;
				НоваяСтрока.ЦеноваяГруппа				= СтрокаТаблицы.ЦеноваяГруппа;
				НоваяСтрока.ВидЦенБазовыйЦеновойГруппы	= Операнд.ВидЦен;
				
			КонецЦикла;
			
		КонецЦикла;
		
	ИначеЕсли ЭтотОбъект.ТипВидаЦен = Перечисления.ТипыВидовЦен.ДинамическийПроцент Тогда
		
		НоваяСтрока					= ТаблицаЗависимыхЦен.Добавить();
		НоваяСтрока.ВидЦенРасчетный = ЭтотОбъект.Ссылка;
		НоваяСтрока.ВидЦенБазовый	= ЭтотОбъект.БазовыйВидЦен;
		
		Для каждого СтрокаТаблицы Из ЭтотОбъект.ЦеновыеГруппы Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ЦеноваяГруппа) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			НоваяСтрока								= ТаблицаЗависимыхЦен.Добавить();
			НоваяСтрока.ВидЦенРасчетный				= ЭтотОбъект.Ссылка;
			НоваяСтрока.ВидЦенБазовый				= ЭтотОбъект.БазовыйВидЦен;
			НоваяСтрока.ЦеноваяГруппа				= СтрокаТаблицы.ЦеноваяГруппа;
			НоваяСтрока.ВидЦенБазовыйЦеновойГруппы	= СтрокаТаблицы.БазовыйВидЦен;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодготовитьТаблицуРегистраОчередьРасчетаЦен(ОчередьРасчетаЦен, СвязиВидовЦен, ЭтотОбъект)
	
	Запрос 			= Новый Запрос;
	Запрос.Текст	= 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ &ВидЦенРасчетный КАК ВидЦенРасчетный, ЗаписиЦен.Номенклатура, ЗаписиЦен.Характеристика, ЛОЖЬ КАК ПересчетВыполнен, &Период КАК ПериодЗаписи
	|ИЗ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(,Актуальность И ВидЦен В(&МассивВидовЦен)) КАК ЗаписиЦен
	|ОБЪЕДИНИТЬ
	|ВЫБРАТЬ РАЗЛИЧНЫЕ &ВидЦенРасчетный КАК ВидЦенРасчетный, ЗаписиЦенКонтрагентов.Номенклатура, ЗаписиЦенКонтрагентов.Характеристика, ЛОЖЬ КАК ПересчетВыполнен, &Период КАК ПериодЗаписи
	|ИЗ РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних(,Актуальность И ВидЦенКонтрагента В(&МассивВидовЦен)) КАК ЗаписиЦенКонтрагентов
	|УПОРЯДОЧИТЬ ПО ВидЦенРасчетный, Номенклатура, Характеристика";
	
	Запрос.УстановитьПараметр("Период", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ВидЦенРасчетный", ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("МассивВидовЦен", СвязиВидовЦен.ВыгрузитьКолонку("ВидЦенБазовый"));
	
	ОчередьРасчетаЦен = Запрос.Выполнить().Выгрузить();
	
КонецПроцедуры

Процедура ИнициализироватьДанные(Ссылка, ДополнительныеСвойства, ЭтотОбъект) Экспорт
	Перем СвязиВидовЦен, ОчередьРасчетаЦен, ПропуститьРегистрациюОчередиЦен;
	
	ПодготовитьТаблицуРегистраЗависимыеВидыЦен(СвязиВидовЦен, ЭтотОбъект);
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("СвязиВидовЦенСлужебный", СвязиВидовЦен);
	
	ДополнительныеСвойства.Свойство("ПропуститьРегистрациюОчередиЦен", ПропуститьРегистрациюОчередиЦен);
	Если НЕ ПропуститьРегистрациюОчередиЦен = Истина Тогда
		
		ПодготовитьТаблицуРегистраОчередьРасчетаЦен(ОчередьРасчетаЦен, СвязиВидовЦен, ЭтотОбъект);
		ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ОчередьРасчетаЦен", ОчередьРасчетаЦен);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИспользуютсяЦеновыеГруппыВДинамическихВидахЦен() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 ЦеноваяГруппа ИЗ Справочник.ВидыЦен.ЦеновыеГруппы");
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

Процедура ПроверитьДублированиеЦеновыхГрупп(Ошибки, ТаблицаСтрок) Экспорт
	
	Если ТаблицаСтрок.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТаблицаЦеновыхГрупп = Новый ТаблицаЗначений;
	ТаблицаЦеновыхГрупп.Колонки.Добавить("НомерСтроки",		Новый ОписаниеТипов("Число"));
	ТаблицаЦеновыхГрупп.Колонки.Добавить("ЦеноваяГруппа",	Новый ОписаниеТипов("СправочникСсылка.ЦеновыеГруппы"));
	
	Для Каждого СтрокаТЧ Из ТаблицаСтрок Цикл
		
		ЗаполнитьЗначенияСвойств(ТаблицаЦеновыхГрупп.Добавить(), СтрокаТЧ);
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЦеновыхГрупп", ТаблицаЦеновыхГрупп);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВременнаяТаблицаЦеновыеГруппы.НомерСтроки КАК НомерСтроки,
	|	ВременнаяТаблицаЦеновыеГруппы.ЦеноваяГруппа КАК ЦеноваяГруппа
	|ПОМЕСТИТЬ ВременнаяТаблицаЦеновыеГруппы
	|ИЗ
	|	&ТаблицаЦеновыхГрупп КАК ВременнаяТаблицаЦеновыеГруппы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВременнаяТаблицаЦеновыеГруппы.НомерСтроки) КАК НомерСтрокиМаксимум,
	|	МИНИМУМ(ВременнаяТаблицаЦеновыеГруппы.НомерСтроки) КАК НомерСтрокиМинимум,
	|	ВременнаяТаблицаЦеновыеГруппы.ЦеноваяГруппа КАК ЦеноваяГруппа
	|ИЗ
	|	ВременнаяТаблицаЦеновыеГруппы КАК ВременнаяТаблицаЦеновыеГруппы
	|ГДЕ
	|	ВременнаяТаблицаЦеновыеГруппы.ЦеноваяГруппа <> ЗНАЧЕНИЕ(Справочник.ЦеновыеГруппы.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаЦеновыеГруппы.ЦеноваяГруппа
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(*) > 1
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтрокиМинимум";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстОшибки = НСтр("ru='Дублирование ценовых групп не допускается: строки %1 и %2 по элементу %3'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, Выборка.НомерСтрокиМинимум, Выборка.НомерСтрокиМаксимум, Выборка.ЦеноваяГруппа);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "УточнитьРасчетПоЦеновымГруппам", ТекстОшибки, "");
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьВсеЦеныПоВидуЦен(ВидЦен) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВидЦен) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЦеныНоменклатуры = РегистрыСведений.ЦеныНоменклатуры.СоздатьНаборЗаписей();
	ЦеныНоменклатуры.Отбор.ВидЦен.Установить(ВидЦен, Истина);
	ЦеныНоменклатуры.Очистить();
	ЦеныНоменклатуры.Записать();
	
КонецПроцедуры

Процедура ОчиститьСвязиВидовЦен(ВидЦен) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 СвязиВидовЦен.ВидЦенРасчетный ИЗ РегистрСведений.СвязиВидовЦенСлужебный КАК СвязиВидовЦен ГДЕ СвязиВидовЦен.ВидЦенРасчетный = &ВидЦенРасчетный");
	Запрос.УстановитьПараметр("ВидЦенРасчетный", ВидЦен);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		НаборЗаписей = РегистрыСведений.СвязиВидовЦенСлужебный.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ВидЦенРасчетный.Установить(Выборка.ВидЦенРасчетный, Истина);
		НаборЗаписей.Записать(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СсылкаНовогоКаталогаЛогированияУдаленияУстаревшихЦен() Экспорт
	
	Идентификатор = "afc86d63-90e8-4449-93e7-f6b72db6606d";
	
	ОписаниеКаталога = Новый Структура;
	ОписаниеКаталога.Вставить("Имя",				НСтр("ru ='Удаленные цены'"));
	ОписаниеКаталога.Вставить("Описание", 			НСтр("ru ='Используется для хранения истории удаленных цен номенклатуры'"));
	ОписаниеКаталога.Вставить("Идентификатор",		Идентификатор);
	ОписаниеКаталога.Вставить("УИД",				Новый УникальныйИдентификатор(Идентификатор));
	
	Возврат ОписаниеКаталога;
	
КонецФункции

Процедура ДобавитьКаталогЛогированияУдаленияСтарыхЦен() Экспорт
	
	ОписаниеКаталога = СсылкаНовогоКаталогаЛогированияУдаленияУстаревшихЦен();
	
	ГруппаЛогирования = Справочники.ПапкиФайлов.ПолучитьСсылку(ОписаниеКаталога.УИД);
	Если ГруппаЛогирования.ПолучитьОбъект() = Неопределено Тогда
		
		НоваяГруппаЛогирования = Справочники.ПапкиФайлов.СоздатьЭлемент();
		НоваяГруппаЛогирования.УстановитьСсылкуНового(ГруппаЛогирования);
		НоваяГруппаЛогирования.Наименование				= ОписаниеКаталога.Имя;
		НоваяГруппаЛогирования.Описание					= ОписаниеКаталога.Описание;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НоваяГруппаЛогирования, Ложь, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает список имен «ключевых» реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Наименование");
	Результат.Добавить("ИдентификаторФормул");
	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()


#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

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

// Процедура получает основной вид цен продажи из пользовательский настроек.
//
Функция ПолучитьОсновнойВидЦенПродажи() Экспорт
	
	ВидЦенПродажи = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.АвторизованныйПользователь(), "ОсновнойВидЦенПродажи");
	
	Возврат ?(ЗначениеЗаполнено(ВидЦенПродажи), ВидЦенПродажи, Справочники.ВидыЦен.Оптовая);
	
КонецФункции// ЗаполнитьВидЦен()

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли