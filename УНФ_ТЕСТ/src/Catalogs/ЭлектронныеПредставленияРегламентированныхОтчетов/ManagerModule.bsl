#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция - Получить наименование
Функция ПолучитьНаименование(ВидОтчета, НачалоПериода, КонецПериода, Организация) Экспорт
	
	ТипДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидОтчета, "ТипДокумента");
	
	Если ТипДокумента = Перечисления.ТипыОтправляемыхДокументов.РеестрСведенийФСС
		ИЛИ ТипДокумента = Перечисления.ТипыОтправляемыхДокументов.ИсходящееУведомлениеФНС
		ИЛИ ВидОтчета = Справочники.ВидыОтправляемыхДокументов.УведомлениеСколковоОсвобождениеОтОбязанностейНалогоплательщика Тогда
		ШаблонНаименования = НСтр("ru = '%1 (%2)'");
	Иначе
		ШаблонНаименования = НСтр("ru = '%1 за %3 (%2)'");
	КонецЕсли;
		
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонНаименования, ВидОтчета, Организация,
				ПолучитьПредставлениеПериода(ВидОтчета, НачалоПериода, КонецПериода));
	
КонецФункции
			
// Функция - Получить представление вида документа
Функция ПолучитьПредставлениеВидаДокумента(Вид) Экспорт
	
	Если Вид = 0 Тогда
		Возврат "П";
	ИначеЕсли Вид = Неопределено Тогда
		Возврат "-";
	Иначе
		Возврат "К/" + Вид;
	КонецЕсли;
	
КонецФункции 

// Функция - Получить представление периода
Функция ПолучитьПредставлениеПериода(ВидОтчета, НачалоПериода, КонецПериода) Экспорт
	
	Если Не ЗначениеЗаполнено(ВидОтчета) Тогда
		Возврат "";
	КонецЕсли;
	
	ТипДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидОтчета, "ТипДокумента");
	
	Если ТипДокумента = Перечисления.ТипыОтправляемыхДокументов.РеестрСведенийФСС
		ИЛИ ТипДокумента = Перечисления.ТипыОтправляемыхДокументов.ИсходящееУведомлениеФНС
		ИЛИ ВидОтчета = Справочники.ВидыОтправляемыхДокументов.УведомлениеСколковоОсвобождениеОтОбязанностейНалогоплательщика Тогда
		Возврат "";
	КонецЕсли;

	Если ЗначениеЗаполнено(НачалоПериода) И ЗначениеЗаполнено(КонецПериода) Тогда
		Возврат ПредставлениеПериода(НачалоПериода, КонецДня(КонецПериода), "ФП=Истина");
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Процедура - Обновить наименование
Процедура ОбновитьНаименование(Параметры) Экспорт
	
	НачатьТранзакцию();
	Попытка
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЭлектронныеПредставленияРегламентированныхОтчетов.Ссылка
		|ИЗ
		|	Справочник.ЭлектронныеПредставленияРегламентированныхОтчетов КАК ЭлектронныеПредставленияРегламентированныхОтчетов
		|ГДЕ
		|	НЕ ЭлектронныеПредставленияРегламентированныхОтчетов.ВидОтчета.ТипДокумента ЕСТЬ NULL ";
		
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ЭлектронныеПредставленияРегламентированныхОтчетов");
		ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "Ссылка");
		Блокировка.Заблокировать();
		

		Пока Выборка.Следующий() Цикл
			ЗагруженныйОтчетОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ЗагруженныйОтчетОбъект.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
		
КонецПроцедуры

//Обработчик обновления БРО, заполняющий данные при переходе с БП2 на БП3
Процедура ЗаполнитьРеквизитыПриПереходе20() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭлектронныеПредставленияРегламентированныхОтчетов.Ссылка,
	|	ЭлектронныеПредставленияРегламентированныхОтчетов.ДатаНачала,
	|	ЭлектронныеПредставленияРегламентированныхОтчетов.ДатаОкончания,
	|	ЭлектронныеПредставленияРегламентированныхОтчетов.Версия,
	|	ЭлектронныеПредставленияРегламентированныхОтчетов.ВидОтчета
	|ИЗ
	|	Справочник.ЭлектронныеПредставленияРегламентированныхОтчетов КАК ЭлектронныеПредставленияРегламентированныхОтчетов
	|ГДЕ
	|	(ЭлектронныеПредставленияРегламентированныхОтчетов.ПредставлениеПериода = """"
	|			ИЛИ ЭлектронныеПредставленияРегламентированныхОтчетов.ПредставлениеВерсии = """")";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОбъектЭП = Выборка.Ссылка.ПолучитьОбъект();
		ОбъектЭП.ПредставлениеВерсии 	= ПолучитьПредставлениеВидаДокумента(Выборка.Версия);
		ОбъектЭП.ПредставлениеПериода 	= ПолучитьПредставлениеПериода(Выборка.ВидОтчета, Выборка.ДатаНачала, Выборка.ДатаОкончания);
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектЭП);
	КонецЦикла;
	
КонецПроцедуры

//Обработчик обновления БРО, заполняющий данные реквизита ВидОтчета при переходе на очередную версию БРО
Процедура ПеренестиРеквизитВидОтчета() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭлектронныеПредставленияРегламентированныхОтчетов.Ссылка,
	|	ЭлектронныеПредставленияРегламентированныхОтчетов.УдалитьВидОтчета
	|ИЗ
	|	Справочник.ЭлектронныеПредставленияРегламентированныхОтчетов КАК ЭлектронныеПредставленияРегламентированныхОтчетов
	|ГДЕ
	|	(ЭлектронныеПредставленияРегламентированныхОтчетов.УдалитьВидОтчета <> ЗНАЧЕНИЕ(Справочник.ВидыОтправляемыхДокументов.ПустаяСсылка)
	|			И ЭлектронныеПредставленияРегламентированныхОтчетов.УдалитьВидОтчета <> ЗНАЧЕНИЕ(Справочник.РегламентированныеОтчеты.ПустаяСсылка)
	|			И ЭлектронныеПредставленияРегламентированныхОтчетов.УдалитьВидОтчета <> НЕОПРЕДЕЛЕНО)";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОбъектЭП = Выборка.Ссылка.ПолучитьОбъект();
		ОбъектЭП.ВидОтчета 			= Выборка.УдалитьВидОтчета;
		ОбъектЭП.УдалитьВидОтчета 	= Неопределено;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектЭП);
	КонецЦикла;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДО = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО.ОбработкаПолученияФормы("Справочник", "ЭлектронныеПредставленияРегламентированныхОтчетов", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

