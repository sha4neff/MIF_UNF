#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Функция возвращает табличную часть, заполненную плановыми начислениями или
// удержаниями сотрудника
//
// Параметры:
//  СтруктураОтбора - Структура, содержащая данные о физ лице, для которого
//                 необходимо найти начисления или удержания      
//
// Возвращаемое значение:
//  ТаблицаЗначений с полученными начислениями или удержаниями.
//
Функция НайтиНачисленияУдержанияСотрудника(СтруктураОтбора, Налог = Ложь) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПлановыеНачисленияИУдержанияСрезПоследних.ВидНачисленияУдержания КАК ВидНачисленияУдержания,
	|	ПлановыеНачисленияИУдержанияСрезПоследних.Валюта КАК Валюта,
	|	ПлановыеНачисленияИУдержанияСрезПоследних.СчетЗатрат КАК СчетЗатрат,
	|	ПлановыеНачисленияИУдержанияСрезПоследних.Сумма КАК Сумма,
	|	ПлановыеНачисленияИУдержанияСрезПоследних.Актуальность КАК Актуальность
	|ИЗ
	|	РегистрСведений.ПлановыеНачисленияИУдержания.СрезПоследних(
	|			&Дата,
	|			Сотрудник = &Сотрудник
	|				И Организация = &Организация
	|				И Регистратор <> &Регистратор
	|				И ВЫБОР
	|					КОГДА &Налог
	|						ТОГДА ВидНачисленияУдержания.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийИУдержаний.Налог)
	|					ИНАЧЕ ВидНачисленияУдержания.Тип <> ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийИУдержаний.Налог)
	|				КОНЕЦ) КАК ПлановыеНачисленияИУдержанияСрезПоследних
	|ГДЕ
	|	ПлановыеНачисленияИУдержанияСрезПоследних.Актуальность";
	
	Запрос.УстановитьПараметр("Сотрудник", СтруктураОтбора.Сотрудник);
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(СтруктураОтбора.Организация));
	Запрос.УстановитьПараметр("Дата", СтруктураОтбора.Дата);
	Запрос.УстановитьПараметр("Регистратор", Ссылка); 
	Запрос.УстановитьПараметр("Налог", Налог);
	
	ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
	МассивРезультат = Новый Массив;
    Для каждого СтрокаТЧ Из ТаблицаРезультат Цикл
		
		СтрокаТабличнойЧасти = Новый Структура();
		СтрокаТабличнойЧасти.Вставить("ВидНачисленияУдержания", СтрокаТЧ.ВидНачисленияУдержания);
        СтрокаТабличнойЧасти.Вставить("Валюта", 				СтрокаТЧ.Валюта);
		СтрокаТабличнойЧасти.Вставить("СчетЗатрат", 			СтрокаТЧ.СчетЗатрат);
		СтрокаТабличнойЧасти.Вставить("Сумма", 					СтрокаТЧ.Сумма);
		СтрокаТабличнойЧасти.Вставить("Актуальность", 			СтрокаТЧ.Актуальность);
		
		МассивРезультат.Добавить(СтрокаТабличнойЧасти);
		
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции // НайтиНачисленияУдержанияСотрудника()

// Выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ) 
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КадровоеПеремещениеСотрудники.НомерСтроки КАК НомерСтроки,
	|	КадровоеПеремещениеСотрудники.Сотрудник КАК Сотрудник,
	|	КадровоеПеремещениеСотрудники.Период КАК Период,
	|	КадровоеПеремещениеСотрудники.КлючСвязи КАК КлючСвязи
	|ПОМЕСТИТЬ ТаблицаСотрудники
	|ИЗ
	|	Документ.КадровоеПеремещение.Сотрудники КАК КадровоеПеремещениеСотрудники
	|ГДЕ
	|	КадровоеПеремещениеСотрудники.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаНачисленияУдержания.НомерСтроки КАК НомерСтроки,
	|	ТаблицаНачисленияУдержания.ВидНачисленияУдержания КАК ВидНачисленияУдержания,
	|	ТаблицаНачисленияУдержания.Валюта КАК Валюта,
	|	ТаблицаСотрудники.Сотрудник КАК Сотрудник,
	|	ТаблицаСотрудники.Период КАК Период
	|ПОМЕСТИТЬ ТаблицаНачисленияУдержания
	|ИЗ
	|	Документ.КадровоеПеремещение.НачисленияУдержания КАК ТаблицаНачисленияУдержания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаСотрудники КАК ТаблицаСотрудники
	|		ПО ТаблицаНачисленияУдержания.КлючСвязи = ТаблицаСотрудники.КлючСвязи
	|			И (ТаблицаНачисленияУдержания.Ссылка = &Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаСотрудники.НомерСтроки КАК НомерСтроки,
	|	Сотрудники.Регистратор КАК Регистратор
	|ИЗ
	|	ТаблицаСотрудники КАК ТаблицаСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	|		ПО (Сотрудники.Организация = &Организация)
	|			И ТаблицаСотрудники.Сотрудник = Сотрудники.Сотрудник
	|			И ТаблицаСотрудники.Период = Сотрудники.Период
	|			И (Сотрудники.Регистратор <> &Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаНачисленияУдержания.НомерСтроки КАК НомерСтроки,
	|	ПлановыеНачисленияИУдержания.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрСведений.ПлановыеНачисленияИУдержания КАК ПлановыеНачисленияИУдержания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаНачисленияУдержания КАК ТаблицаНачисленияУдержания
	|		ПО (ПлановыеНачисленияИУдержания.Организация = &Организация)
	|			И ПлановыеНачисленияИУдержания.Сотрудник = ТаблицаНачисленияУдержания.Сотрудник
	|			И ПлановыеНачисленияИУдержания.ВидНачисленияУдержания = ТаблицаНачисленияУдержания.ВидНачисленияУдержания
	|			И ПлановыеНачисленияИУдержания.Валюта = ТаблицаНачисленияУдержания.Валюта
	|			И ПлановыеНачисленияИУдержания.Период = ТаблицаНачисленияУдержания.Период
	|			И (ПлановыеНачисленияИУдержания.Регистратор <> &Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(ТаблицаСотрудникиДублиСтрок.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаСотрудникиДублиСтрок.Сотрудник КАК Сотрудник
	|ИЗ
	|	ТаблицаСотрудники КАК ТаблицаСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаСотрудники КАК ТаблицаСотрудникиДублиСтрок
	|		ПО ТаблицаСотрудники.НомерСтроки <> ТаблицаСотрудникиДублиСтрок.НомерСтроки
	|			И ТаблицаСотрудники.Сотрудник = ТаблицаСотрудникиДублиСтрок.Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСотрудникиДублиСтрок.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
	
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Регистр "Сотрудники".
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = НСтр(
				"ru = 'В строке №%Номер% табл. части ""Сотрудники"" период действия приказа противоречит кадровому приказу ""%КадровыйПриказ%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", ВыборкаИзРезультатаЗапроса.НомерСтроки); 
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КадровыйПриказ%", ВыборкаИзРезультатаЗапроса.Регистратор);
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Период",
				Отказ);
		КонецЦикла;
	КонецЕсли;

	// Регистр "Плановые начисления и удержания".
	Если НЕ МассивРезультатов[3].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = НСтр(
				"ru = 'В строке №%Номер% табл. части ""Начисления и удержания"" период действия приказа противоречит кадровому приказу ""%КадровыйПриказ%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", ВыборкаИзРезультатаЗапроса.НомерСтроки); 
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КадровыйПриказ%", ВыборкаИзРезультатаЗапроса.Регистратор);
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"НачисленияУдержания",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Период",
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	// Дубли строк.
	Если НЕ МассивРезультатов[4].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[4].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = НСтр(
				"ru = 'В строке №%Номер% табл. части ""Сотрудники"" сотрудник указывается повторно.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", ВыборкаИзРезультатаЗапроса.НомерСтроки);
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Сотрудник",
				Отказ);
		КонецЦикла;
	КонецЕсли;	 
	
КонецПроцедуры

// Выполняет контроль противоречий.
//
Процедура ВыполнитьКонтроль(ДополнительныеСвойства, Отказ) 
	
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.Сотрудник КАК Сотрудник,
	|	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки,
	|	Сотрудники.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаСотрудники.Сотрудник КАК Сотрудник,
	|		ТаблицаСотрудники.НомерСтроки КАК НомерСтроки,
	|		МАКСИМУМ(Сотрудники.Период) КАК Период
	|	ИЗ
	|		ТаблицаСотрудники КАК ТаблицаСотрудники
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	|			ПО (Сотрудники.Сотрудник = ТаблицаСотрудники.Сотрудник)
	|				И (Сотрудники.Организация = &Организация)
	|				И (Сотрудники.Период <= ТаблицаСотрудники.Период)
	|				И (Сотрудники.Регистратор <> &Ссылка)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаСотрудники.Сотрудник,
	|		ТаблицаСотрудники.НомерСтроки) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	|		ПО ВложенныйЗапрос.Сотрудник = Сотрудники.Сотрудник
	|			И ВложенныйЗапрос.Период = Сотрудники.Период
	|			И (Сотрудники.Организация = &Организация)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
	
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", ДополнительныеСвойства.ДляПроведения.Организация);
	
	Результат = Запрос.Выполнить();
	
	// Сотрудник не принят в организацию на дату перемещения.
	ВыборкаИзРезультатаЗапроса = Результат.Выбрать();
	Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
		Если Не ЗначениеЗаполнено(ВыборкаИзРезультатаЗапроса.СтруктурнаяЕдиница) Тогда
		    ТекстСообщения = НСтр(
				"ru = 'В строке №%Номер% табл. части ""Сотрудники"" сотрудник %Сотрудник% не принят на работу в организацию %Организация%.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", ВыборкаИзРезультатаЗапроса.НомерСтроки); 
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Сотрудник%", ВыборкаИзРезультатаЗапроса.Сотрудник); 
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Организация%", ДополнительныеСвойства.ДляПроведения.Организация);
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Сотрудник",
				Отказ);
		КонецЕсли; 
	КонецЦикла;	 
	
КонецПроцедуры

// Выполняет контроль штатного расписания.
//
Процедура ВыполнитьКонтрольШтатногоРасписания(ДополнительныеСвойства, Отказ) 
	
	Если Отказ ИЛИ НЕ Константы.ФункциональнаяОпцияВестиШтатноеРасписание.Получить() Тогда
		Возврат;	
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийКадровоеПеремещение.ИзменениеСпособаОплаты Тогда
		Возврат;
	КонецЕсли; 
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	ВЫБОР
	                      |		КОГДА ЕСТЬNULL(ИтогШтатноеРасписание.КоличествоСтавокПоШР, 0) - ЕСТЬNULL(ИтогЗанятоСтавок.ЗанимаемыхСтавок, 0) < 0
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК ПротиворечиеШР,
	                      |	ВЫБОР
	                      |		КОГДА ИтогШтатноеРасписание.НомерСтроки ЕСТЬ NULL
	                      |			ТОГДА ИтогЗанятоСтавок.НомерСтроки
	                      |		ИНАЧЕ ИтогШтатноеРасписание.НомерСтроки
	                      |	КОНЕЦ КАК НомерСтроки
	                      |ИЗ
	                      |	(ВЫБРАТЬ
	                      |		МаксимальныеПериодыШтатногоРасписания.НомерСтроки КАК НомерСтроки,
	                      |		ШтатноеРасписание.КоличествоСтавок КАК КоличествоСтавокПоШР,
	                      |		ШтатноеРасписание.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	                      |		ШтатноеРасписание.Должность КАК Должность,
	                      |		ШтатноеРасписание.Организация КАК Организация
	                      |	ИЗ
	                      |		(ВЫБРАТЬ
	                      |			ШтатноеРасписание.Организация КАК Организация,
	                      |			ШтатноеРасписание.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	                      |			ШтатноеРасписание.Должность КАК Должность,
	                      |			МАКСИМУМ(ШтатноеРасписание.Период) КАК Период,
	                      |			КадровоеПеремещениеСотрудники.НомерСтроки КАК НомерСтроки
	                      |		ИЗ
	                      |			Документ.КадровоеПеремещение.Сотрудники КАК КадровоеПеремещениеСотрудники
	                      |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ШтатноеРасписание КАК ШтатноеРасписание
	                      |				ПО (ШтатноеРасписание.Организация = &Организация)
	                      |					И КадровоеПеремещениеСотрудники.СтруктурнаяЕдиница = ШтатноеРасписание.СтруктурнаяЕдиница
	                      |					И КадровоеПеремещениеСотрудники.Должность = ШтатноеРасписание.Должность
	                      |					И КадровоеПеремещениеСотрудники.Период >= ШтатноеРасписание.Период
	                      |		ГДЕ
	                      |			КадровоеПеремещениеСотрудники.Ссылка = &Ссылка
	                      |		
	                      |		СГРУППИРОВАТЬ ПО
	                      |			ШтатноеРасписание.Должность,
	                      |			ШтатноеРасписание.СтруктурнаяЕдиница,
	                      |			ШтатноеРасписание.Организация,
	                      |			КадровоеПеремещениеСотрудники.НомерСтроки) КАК МаксимальныеПериодыШтатногоРасписания
	                      |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтатноеРасписание КАК ШтатноеРасписание
	                      |			ПО МаксимальныеПериодыШтатногоРасписания.Период = ШтатноеРасписание.Период
	                      |				И МаксимальныеПериодыШтатногоРасписания.Организация = ШтатноеРасписание.Организация
	                      |				И МаксимальныеПериодыШтатногоРасписания.СтруктурнаяЕдиница = ШтатноеРасписание.СтруктурнаяЕдиница
	                      |				И МаксимальныеПериодыШтатногоРасписания.Должность = ШтатноеРасписание.Должность) КАК ИтогШтатноеРасписание
	                      |		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	                      |			Сотрудники.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	                      |			Сотрудники.Должность КАК Должность,
	                      |			СУММА(Сотрудники.ЗанимаемыхСтавок) КАК ЗанимаемыхСтавок,
	                      |			Сотрудники.Организация КАК Организация,
	                      |			МаксимальныеПериодыСотрудников.НомерСтроки КАК НомерСтроки
	                      |		ИЗ
	                      |			(ВЫБРАТЬ
	                      |				Сотрудники.Организация КАК Организация,
	                      |				МАКСИМУМ(Сотрудники.Период) КАК Период,
	                      |				КадровоеПеремещениеСотрудники.НомерСтроки КАК НомерСтроки,
	                      |				Сотрудники.Сотрудник КАК Сотрудник,
	                      |				КадровоеПеремещениеСотрудники.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	                      |				КадровоеПеремещениеСотрудники.Должность КАК Должность
	                      |			ИЗ
	                      |				Документ.КадровоеПеремещение.Сотрудники КАК КадровоеПеремещениеСотрудники
	                      |					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	                      |					ПО (Сотрудники.Организация = &Организация)
	                      |						И КадровоеПеремещениеСотрудники.Период >= Сотрудники.Период
	                      |			ГДЕ
	                      |				КадровоеПеремещениеСотрудники.Ссылка = &Ссылка
	                      |			
	                      |			СГРУППИРОВАТЬ ПО
	                      |				Сотрудники.Организация,
	                      |				КадровоеПеремещениеСотрудники.НомерСтроки,
	                      |				Сотрудники.Сотрудник,
	                      |				КадровоеПеремещениеСотрудники.СтруктурнаяЕдиница,
	                      |				КадровоеПеремещениеСотрудники.Должность) КАК МаксимальныеПериодыСотрудников
	                      |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	                      |				ПО (Сотрудники.Организация = &Организация)
	                      |					И МаксимальныеПериодыСотрудников.Сотрудник = Сотрудники.Сотрудник
	                      |					И МаксимальныеПериодыСотрудников.СтруктурнаяЕдиница = Сотрудники.СтруктурнаяЕдиница
	                      |					И МаксимальныеПериодыСотрудников.Должность = Сотрудники.Должность
	                      |					И МаксимальныеПериодыСотрудников.Период = Сотрудники.Период
	                      |		ГДЕ
	                      |			Сотрудники.СтруктурнаяЕдиница <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	                      |		
	                      |		СГРУППИРОВАТЬ ПО
	                      |			Сотрудники.СтруктурнаяЕдиница,
	                      |			Сотрудники.Должность,
	                      |			Сотрудники.Организация,
	                      |			МаксимальныеПериодыСотрудников.НомерСтроки) КАК ИтогЗанятоСтавок
	                      |		ПО ИтогШтатноеРасписание.НомерСтроки = ИтогЗанятоСтавок.НомерСтроки
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	НомерСтроки");
						  
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ПротиворечиеШР Тогда
			ТекстСообщения = НСтр("ru = 'Строка №%Номер% табл. части ""Сотрудники"": в штатном расписании не предусмотрены ставки для приема сотрудника!'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", Выборка.НомерСтроки);
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Сотрудники",
				Выборка.НомерСтроки,
				"ЗанимаемыхСтавок",
				);
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.КадровоеПеремещение.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	УправлениеНебольшойФирмойСервер.ОтразитьСотрудники(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьПлановыеНачисленияИУдержания(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Отражение текущих кадровых данных
	РегистрыСведений.ТекущиеКадровыеДанныеСотрудников.ОбновитьТекущиеКадровыеДанныеСотрудников(ЭтотОбъект);
	
	// Контроль
	ВыполнитьКонтроль(ДополнительныеСвойства, Отказ);
	ВыполнитьКонтрольШтатногоРасписания(ДополнительныеСвойства, Отказ);	
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// В обработчике события ОбработкаПроверкиЗаполнения документа выполняется
// копирование и обнуление проверяемых реквизитов для исключения стандартной
// проверки заполнения платформой и последующей проверки средствами встроенного языка.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ); 
	
	Если ВидОперации = Перечисления.ВидыОперацийКадровоеПеремещение.ПеремещениеИИзменениеСпособаОплаты Тогда
		ПроверяемыеРеквизиты.Добавить("Сотрудники.СтруктурнаяЕдиница");
		ПроверяемыеРеквизиты.Добавить("Сотрудники.Должность");
		ПроверяемыеРеквизиты.Добавить("Сотрудники.ЗанимаемыхСтавок");
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
		
	// Отражение текущих кадровых данных
	РегистрыСведений.ТекущиеКадровыеДанныеСотрудников.ОбновитьТекущиеКадровыеДанныеСотрудников(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли