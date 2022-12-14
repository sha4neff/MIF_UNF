// Общий модуль (выполняется на стороне сервера) модуля "Конструктор процессов для 1С:УНФ"
// Разработчик Компания "Аналитика. Проекты и решения" +7 495 005-1653, https://kp-unf.ru

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает параметр сеанса запрещающий пользователю доступ
// к чужим документам, бизнес-процессам и задачам. В параметрах процедуры пердается ссылка на пользователя
// Параметры:
// 	СсылкаНаПользователя - Ссылка на пользователя
Процедура УстановитьПараметрыСеансаЗапретаДоступаКЗаписям(СсылкаНаПользователя) Экспорт
	
КонецПроцедуры

// Процедура устанавливает параметр сеанса ТекущийПользователь по переданному в нее значению
// В параметрах процедуры передается ссылка на пользователя
// Параметры:
// 	СсылкаНаПользователя - Ссылка на пользователя
Процедура УстановитьПараметрСеансаТекущийПользователь(СсылкаНаПользователя) Экспорт
	
	ПараметрыСеанса.ТекущийПользователь=СсылкаНаПользователя;
	ПараметрыСеанса.аПустойПользователь=Справочники.Пользователи.ПустаяСсылка();
	
КонецПроцедуры

// Функция находит и возвращает регламентированное задание по переданному в аргументе имени
// Параметры:
// 	ИмяРегламентированогоЗадания - имя регламентированного задания
// Возвращаемое значение: Регламентированное задание
Функция НайтиРегламентированноеЗадание(ИмяРегламентированогоЗадания) Экспорт
	
	РеглУправлениеКБП=РегламентныеЗадания.НайтиПредопределенное(ИмяРегламентированогоЗадания);
	
	Возврат РеглУправлениеКБП;
	
КонецФункции
	
// Процедура фиксирует факт просмотра объекта, переданного в аргументе процедуры, текущим пользователем
// Параметры:
//		Объект - объект который необходимо зафиксировать в просмотрах
Процедура ЗафиксироватьПросмотрОбъекта(Объект) Экспорт
	
	ОбъектСсылка=Объект.Ссылка;
	ПользовательСсылка=Пользователи.ТекущийПользователь();
	ДатаВремяПросмотра=ТекущаяДата();
	
	//запишем в регистр
	РегПросмотра=РегистрыСведений.КП_ПросмотрОбъектовПользователями.СоздатьНаборЗаписей();
	РегПросмотра.Отбор.Объект.Установить(ОбъектСсылка);
	РегПросмотра.Отбор.Пользователь.Установить(ПользовательСсылка);
	
	РегПросмотра.Прочитать();
	
	Если РегПросмотра.Количество()>0 Тогда
		ЗаписьПросмотра=РегПросмотра[0];
	Иначе
		ЗаписьПросмотра=РегПросмотра.Добавить();
	КонецЕсли;
	
	ЗаписьПросмотра.Объект=ОбъектСсылка;
	ЗаписьПросмотра.Пользователь=ПользовательСсылка;
	ЗаписьПросмотра.ПоследнийПросмотр=ДатаВремяПросмотра;
	
	Попытка
		РегПросмотра.Записать(Истина);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры
	
// Функция получает количество просмотров объекта
// Параметры:
// 	Объект - Ссылка на объект
// Возвращаемое значение: Число 
Функция ПолучитьКоличествоПросмотровОбъекта(Объект) Экспорт
	
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	КОЛИЧЕСТВО(КП_ПросмотрОбъектовПользователями.Объект) КАК КоличествоПросмотров
	                    |ИЗ
	                    |	РегистрСведений.КП_ПросмотрОбъектовПользователями КАК КП_ПросмотрОбъектовПользователями
	                    |ГДЕ
	                    |	КП_ПросмотрОбъектовПользователями.Объект = &Объект");
						
	Запрос.УстановитьПараметр("Объект", Объект);
	
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	
	Если Выборка.Следующий() Тогда
		Возврат Число(Выборка.КоличествоПросмотров);
		
	Иначе
		Возврат 0;
		
	КонецЕсли;
	
КонецФункции
	
// Процедура отменяет просмотр объекта
// Параметры:
// 	ОбъектСсылка - Ссылка на объект
// 	ПользовательИсключение - Ссылка на пользователя
Процедура ОтменитьПросмотрОбъекта(ОбъектСсылка, ПользовательИсключение=Неопределено) Экспорт
	
	РегСведений=РегистрыСведений.КП_ПросмотрОбъектовПользователями.СоздатьНаборЗаписей();

	Если НЕ ЗначениеЗаполнено(ПользовательИсключение) Тогда
		//очистим все просмотры объекта
		РегСведений.Отбор.Объект.Установить(ОбъектСсылка);
		Попытка
			РегСведений.Записать(Истина);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		КонецПопытки;
		
		Возврат;
		
	КонецЕсли;
	
	//очистим просмотры пользователей, кроме указанного в аргументе
	
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	КП_ПросмотрОбъектовПользователями.Объект,
	                    |	КП_ПросмотрОбъектовПользователями.Пользователь
	                    |ИЗ
	                    |	РегистрСведений.КП_ПросмотрОбъектовПользователями КАК КП_ПросмотрОбъектовПользователями
	                    |ГДЕ
	                    |	КП_ПросмотрОбъектовПользователями.Пользователь <> &Пользователь");
						
	Запрос.УстановитьПараметр("Пользователь", ПользовательИсключение);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	
	НачатьТранзакцию();
	
	Пока Выборка.Следующий() Цикл
		
		Объект=Выборка.Объект;
		Пользователь=Выборка.Пользователь;
		РегСведений.Отбор.Объект.Установить(Объект);
		РегСведений.Отбор.Пользователь.Установить(Пользователь);
		
		Попытка
			РегСведений.Записать(Истина);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

// Функция получает таблицу всех задач документа
// Параметры:
// 	ДокументСсылка - Ссылка на документ
// Возвращаемое значение: Таблица значений
Функция ПолучитьТаблицуВсехЗадачДокумента(ДокументСсылка) Экспорт
	
	ТекстЗапроса="ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |	ПараметрВыполнениеПроцентЗадачСрезПоследних.ЗначениеПараметра КАК ВыполнениеПроцент,
	             |	ЗадачиДокумента.ЗадачаПроцесса КАК Задача,
				 |	ЗадачиДокумента.ЗадачаПроцесса.Дата КАК ДатаСозданияЗадачи,
	             |	ЗадачиДокумента.ЗадачаПроцесса.Исполнитель КАК Исполнитель,
	             |	ЗадачиДокумента.ЗадачаПроцесса.Наименование КАК Наименование,
	             |	ЗадачиДокумента.ЗадачаПроцесса.ДатаВыполненияФакт КАК ДатаВыполненияФакт,
	             |	КП_РецензииКонтролеровСрезПоследних.ТекстРецензии КАК РецензияКонтролера,
	             |	ЗадачиДокумента.ЗадачаПроцесса.ТекстовыйРезультат КАК ТекстРезультатаИсполнителя
	             |ИЗ
	             |	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |		КП_Задача.Ссылка КАК ЗадачаПроцесса
	             |	ИЗ
	             |		(ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |			КП_СсылкиПроцессов.БизнесПроцесс КАК БизнесПроцесс
	             |		ИЗ
	             |			РегистрСведений.КП_СсылкиПроцессов КАК КП_СсылкиПроцессов
	             |		ГДЕ
	             |			КП_СсылкиПроцессов.Объект = &ТекущийДокумент) КАК БизнесПроцессыДокумента
	             |			ЛЕВОЕ СОЕДИНЕНИЕ Задача.КП_Задача КАК КП_Задача
	             |			ПО БизнесПроцессыДокумента.БизнесПроцесс = КП_Задача.БизнесПроцесс
	             |	ГДЕ
	             |		КП_Задача.ПометкаУдаления = ЛОЖЬ
	             |		И КП_Задача.ТочкаМаршрута <> &СлужебнаяТочкаМаршрута) КАК ЗадачиДокумента
	             |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КП_ПараметрыЗадач.СрезПоследних(&ТекущаяДата, ПараметрЗадачи = &ПараметрВыполнениеПроцент) КАК ПараметрВыполнениеПроцентЗадачСрезПоследних
	             |		ПО ЗадачиДокумента.ЗадачаПроцесса = ПараметрВыполнениеПроцентЗадачСрезПоследних.Задача
	             |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КП_РецензииКонтролеров.СрезПоследних(&ТекущаяДата, ) КАК КП_РецензииКонтролеровСрезПоследних
	             |		ПО ЗадачиДокумента.ЗадачаПроцесса = КП_РецензииКонтролеровСрезПоследних.ЗадачаИсполнителя";
	
	Запрос=Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("ТекущийДокумент", ДокументСсылка);
	Запрос.УстановитьПараметр("СлужебнаяТочкаМаршрута", БизнесПроцессы.КП_БизнесПроцесс.ТочкиМаршрута.ВыполнениеКорпоративногоПроцесса);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.УстановитьПараметр("ПараметрВыполнениеПроцент", ПланыВидовХарактеристик.КП_ПараметрыЗадач.ВыполнениеПроцент);
	
	УстановитьПривилегированныйРежим(Истина);

	ТаблицаЗапроса=Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой);
	
	//дополним таблицу данными
	ТаблицаЗапроса.Колонки.Добавить("ИсполнительФИО");
	Для Каждого СтрокаТЧ Из ТаблицаЗапроса Цикл
		СтрокаТЧ.ИсполнительФИО=КП_ОбщееСервер.ПадежКраткоеФИО(СтрокаТЧ.Исполнитель, 1);
	КонецЦикла;
	
	Возврат ТаблицаЗапроса;
	
КонецФункции

// Функция возвращает представление значения
// Параметры:
// 	Парам - Параметр
// Возвращаемое значение: Строка 
Функция ПолучитьПредставлениеЗначения(Парам) Экспорт
	Возврат Строка(Парам);
КонецФункции

#КонецОбласти
