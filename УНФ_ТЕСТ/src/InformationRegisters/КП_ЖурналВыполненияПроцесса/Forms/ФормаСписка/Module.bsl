
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Пользователь=СокрЛП(Пользователи.ТекущийПользователь());
	ОтборПоБизнесПроцессу=КП_ОбщееСервер.ЗагрузитьНастройкуПользователя("ЖурналВыполненияПроцессов.ФормаСписка", "ОтборПоБизнесПроцессу", , Пользователь);
	
	ОбновитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоБизнесПроцессуПриИзменении(Элемент)
	
	ОбновитьСписок();
	
	Пользователь=СокрЛП(ПользователиКлиентСервер.ТекущийПользователь());
	КП_ОбщееСервер.СохранитьНастройкуПользователя("ЖурналВыполненияПроцессов.ФормаСписка", "ОтборПоБизнесПроцессу", ОтборПоБизнесПроцессу, , Пользователь);
	
КонецПроцедуры

Процедура ОбновитьСписок()
	
	ТекстЗапроса="ВЫБРАТЬ
	             |	РегистрСведенийаДокументооборотЖурналВыполненияПроцесса.ДатаЗаписи КАК ДатаЗаписи,
	             |	РегистрСведенийаДокументооборотЖурналВыполненияПроцесса.БизнесПроцесс КАК БизнесПроцесс,
	             |	РегистрСведенийаДокументооборотЖурналВыполненияПроцесса.ТочкаКБП КАК ТочкаКБП,
	             |	РегистрСведенийаДокументооборотЖурналВыполненияПроцесса.ТекстЗаписи КАК ТекстЗаписи,
	             |	РегистрСведенийаДокументооборотЖурналВыполненияПроцесса.УникальныйИдентификаторЗаписи КАК УникальныйИдентификаторЗаписи,
	             |	РегистрСведенийаДокументооборотЖурналВыполненияПроцесса.НомерЗаписи КАК НомерЗаписи,
	             |	РегистрСведенийаДокументооборотЖурналВыполненияПроцесса.ВидСобытияЧисло КАК ВидСобытияЧисло
	             |ИЗ
	             |	РегистрСведений.КП_ЖурналВыполненияПроцесса КАК РегистрСведенийаДокументооборотЖурналВыполненияПроцесса
	             |ГДЕ
	             |	ИСТИНА";
		
	Если ЗначениеЗаполнено(ОтборПоБизнесПроцессу) Тогда
		ТекстЗапроса=ТекстЗапроса+" И РегистрСведенийаДокументооборотЖурналВыполненияПроцесса.БизнесПроцесс = &БизнесПроцесс";
	КонецЕсли;
	
	Если ОтборВидСобытий>0 Тогда
		ТекстЗапроса=ТекстЗапроса+" И РегистрСведенийаДокументооборотЖурналВыполненияПроцесса.ВидСобытияЧисло = &ВидСобытия";
	КонецЕсли;
	
	Список.ТекстЗапроса=ТекстЗапроса;
	
	Если ЗначениеЗаполнено(ОтборПоБизнесПроцессу) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("БизнесПроцесс", ОтборПоБизнесПроцессу);
	КонецЕсли;
	
	Если ОтборВидСобытий>0 Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ВидСобытия", ОтборВидСобытий);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчисткаЖурнала(Команда)
	ДатаОчистки=НачалоГода(ТекущаяДата());
	ПоказатьВопрос(Новый ОписаниеОповещения("ОчисткаЖурналаЗавершение2", ЭтотОбъект, Новый Структура("ДатаОчистки", ДатаОчистки)), НСтр("ru='Начать процедуру очистки журнала выполнения процессов? 
			|Далее необходимо будет ввести дату до которой все записи будут очищены. 
			|Сами процессы и задачи останутся. Продолжить?'; en='Do you want to start clearing log process?.
			|You will need to enter the date befor all log records will be cleared.';"), РежимДиалогаВопрос.ДаНет, , , КП_ОбщееКлиент.ЗаголовокДиалога());

КонецПроцедуры

&НаКлиенте
Процедура ОчисткаЖурналаЗавершение2(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ДатаОчистки = ДополнительныеПараметры.ДатаОчистки;
    
    
    Если РезультатВопроса=КодВозвратаДиалога.Нет Тогда
        
        Возврат;
    КонецЕсли;
    
    ПоказатьВводДаты(Новый ОписаниеОповещения("ОчисткаЖурналаЗавершение1", ЭтотОбъект, Новый Структура("ДатаОчистки", ДатаОчистки)), ДатаОчистки, НСтр("ru='Введите дату, до которой записи будут удалены'; en='Enter the date before all records will be cleared';"), ЧастиДаты.Дата);

КонецПроцедуры

&НаКлиенте
Процедура ОчисткаЖурналаЗавершение1(Дата, ДополнительныеПараметры) Экспорт
    
    ДатаОчистки = ?(Дата = Неопределено, ДополнительныеПараметры.ДатаОчистки, Дата);
    
    
    Если НЕ (Дата <> Неопределено) Тогда
        Возврат;
    КонецЕсли;
    
    СтрокаВопроса=НСтр("ru='Все записи журнала выполнения процессов будут удалены до даты '; en='All records will be cleared prior the date ';")+Формат(ДатаОчистки, "ДФ=dd.MM.yyyy")+НСтр("ru='. Продолжить?'; en='. Do you want to continue?';");
    
    ПоказатьВопрос(Новый ОписаниеОповещения("ОчисткаЖурналаЗавершение", ЭтотОбъект, Новый Структура("ДатаОчистки", ДатаОчистки)), СтрокаВопроса, РежимДиалогаВопрос.ДаНет, , , КП_ОбщееКлиент.ЗаголовокДиалога());

КонецПроцедуры

&НаКлиенте
Процедура ОчисткаЖурналаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ДатаОчистки = ДополнительныеПараметры.ДатаОчистки;
    
    
    Если РезультатВопроса=КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    Если КП_Процессы.ОчиститьЖурналПроцессов(ДатаОчистки) Тогда
        Состояние(НСтр("ru='Журнал процессов очищен до указанной даты';en='Processes log cleared prior entered date'"));
        
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидСобытийПриИзменении(Элемент)
	ОбновитьСписок();
	Состояние("Список обновлен");
КонецПроцедуры

