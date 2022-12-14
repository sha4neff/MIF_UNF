#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПериодВыборки.ДатаНачала=НачалоДня(ТекущаяДата());
	ПериодВыборки.ДатаОкончания=КонецДня(ТекущаяДата());
	
	Объект.ТолькоНеВыполненные=Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьСписокЗадач(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.Исполнитель) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Please fill a user field.';ru='Укажите исполнителя.'"), 60, КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
	КонецЕсли;
	
	Если Объект.ЗадачиИсполнителя.Количество()>0 Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("СформироватьСписокЗадачЗавершение", ЭтотОбъект), НСтр("en='The table will be cleared before clearing. Do you want to continue?';ru='Перед заполнением таблица задач будет очищена. Продолжить?'"), РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да, КП_ОбщееКлиент.ЗаголовокДиалога(), КодВозвратаДиалога.Нет);
        Возврат;	
		
	КонецЕсли;
	
    СформироватьСписокЗадачФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСписокЗадачЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса=КодВозвратаДиалога.Нет Тогда
        Возврат;
        
    Иначе
        Объект.ЗадачиИсполнителя.Очистить();	
        
    КонецЕсли;	
    
    
    СформироватьСписокЗадачФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура СформироватьСписокЗадачФрагмент()
    
    ЗаполнитьТаблицуЗадач();        
    
    Состояние("Формирование списска выполнено");
    
    СписокЗадачСформирован=Истина;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЗадач()
	
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	КП_Задача.Ссылка КАК Задача,
	                    |	КП_Задача.Автор КАК Автор,
	                    |	КП_Задача.Наименование КАК Наименование,
						|	КП_Задача.Исполнитель КАК Исполнитель,
	                    |	КП_Задача.ДатаВыполненияПлан КАК СрокВыполнения,
						|	Истина КАК Включено
	                    |ИЗ
	                    |	Задача.КП_Задача КАК КП_Задача
	                    |ГДЕ
	                    |	КП_Задача.ПометкаУдаления = ЛОЖЬ
	                    |	И КП_Задача.Исполнитель = &Исполнитель
	                    |	И КП_Задача.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
						|	УсловиеВыполнена");
						
						
	Запрос.УстановитьПараметр("Исполнитель", Объект.Исполнитель);
	Запрос.УстановитьПараметр("ДатаНачала", ПериодВыборки.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ПериодВыборки.ДатаОкончания);
	
	Если Объект.ТолькоНеВыполненные Тогда
		Запрос.Текст=СтрЗаменить(Запрос.Текст, "УсловиеВыполнена", " И КП_Задача.Выполнена = Ложь");
	Иначе
		Запрос.Текст=СтрЗаменить(Запрос.Текст, "УсловиеВыполнена", "");
	КонецЕсли;
	
	ТаблицаВыборки=Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой);
	Объект.ЗадачиИсполнителя.Загрузить(ТаблицаВыборки);
			
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Для Каждого СтрокаТЧ Из Объект.ЗадачиИсполнителя Цикл
		СтрокаТЧ.Включено=Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	Для Каждого СтрокаТЧ Из Объект.ЗадачиИсполнителя Цикл
		СтрокаТЧ.Включено=Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗамену(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.ИсполнительНовый) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Please fill a new user field.';ru='Укажите нового исполнителя.'"), 60, КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
	КонецЕсли;
	
	Если Объект.ЗадачиИсполнителя.Количество()=0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Task list is empty.';ru='Список задач пуст. Замена не выполнена.'"), 60, КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;

	КонецЕсли; 
	
	ЗаменитьИсполнителей();

КонецПроцедуры

&НаСервере
Процедура ЗаменитьИсполнителей()
	Для Каждого СтрокаТЧ Из Объект.ЗадачиИсполнителя Цикл
		Если НЕ СтрокаТЧ.Включено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗадачаОбъект=СтрокаТЧ.Задача.ПолучитьОбъект();
		ЗадачаОбъект.Исполнитель=Объект.ИсполнительНовый;
		
		Попытка
			ЗадачаОбъект.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Продолжить;
		КонецПопытки;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выполнено: "+СтрокаТЧ.Наименование);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиИсполнителяЗадачаПриИзменении(Элемент)
	
	СтрокаТЧ=Элементы.ЗадачиИсполнителя.ТекущиеДанные;
	
	Если СтрокаТЧ=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Задача=СтрокаТЧ.Задача;
	
	Если НЕ ЗначениеЗаполнено(Задача) Тогда
		СтрокаТЧ.Наименование="";
		СтрокаТЧ.Включено=Ложь;
		СтрокаТЧ.Автор="";
		СтрокаТЧ.СрокВыполнения="";
		СтрокаТЧ.Исполнитель="";

		
	КонецЕсли;
	
	СтруктураЗадачи=ПолучитьСтруктуруЗадачи(Задача);
	СтрокаТЧ.Наименование=СтруктураЗадачи.Наименование;
	СтрокаТЧ.Автор=СтруктураЗадачи.Автор;
	СтрокаТЧ.СрокВыполнения=СтруктураЗадачи.СрокВыполнения;
	СтрокаТЧ.Исполнитель=СтруктураЗадачи.Исполнитель;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруЗадачи(Задача)
	СтруктураЗадачи=Новый Структура;
	
	СтруктураЗадачи.Вставить("Наименование", Задача.Наименование);
	СтруктураЗадачи.Вставить("Автор", Задача.Автор);
	СтруктураЗадачи.Вставить("Исполнитель", Задача.Исполнитель);
	
	Если ТипЗнч(Задача)=Тип("ЗадачаСсылка.КП_Задача") Тогда
		СтруктураЗадачи.Вставить("СрокВыполнения", Задача.ДатаВыполненияПлан);
		
	ИначеЕсли ТипЗнч(Задача)=Тип("ЗадачаСсылка.КП_Задача") Тогда
		СтруктураЗадачи.Вставить("СрокВыполнения", Задача.СрокИсполнения);
		
	КонецЕсли;
	
	Возврат СтруктураЗадачи;
КонецФункции

#КонецОбласти
