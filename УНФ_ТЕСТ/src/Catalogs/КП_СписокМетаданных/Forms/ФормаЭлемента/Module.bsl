#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.Родитель) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Создавать свои объекты можно только в группе ""Свойства"", ""Числа"" и ""Строки"".'"));
			Отказ=Истина;
			Возврат;
		КонецЕсли;
		
		Если НЕ Объект.Родитель=Справочники.КП_СписокМетаданных.Свойства
			И НЕ Объект.Родитель.ПринадлежитЭлементу(Справочники.КП_СписокМетаданных.Свойства)
			И НЕ Объект.Родитель=Справочники.КП_СписокМетаданных.Числа
			И НЕ Объект.Родитель=Справочники.КП_СписокМетаданных.Строки
			
		Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Создавать свои объекты можно только в группе ""Свойства"", ""Числа"" и ""Строки"".'"));
			Отказ=Истина;
			Возврат;
			
		КонецЕсли;
		
		Если Объект.Родитель=Справочники.КП_СписокМетаданных.Числа Тогда
			Объект.ПолноеНаименование="Число";
			
		ИначеЕсли Объект.Родитель=Справочники.КП_СписокМетаданных.Строки Тогда
			Объект.ПолноеНаименование="Строка";
			
			
		Иначе
			Если  (ЗначениеЗаполнено(Объект.Родитель) 
				И (Объект.Родитель=Справочники.КП_СписокМетаданных.Свойства ИЛИ Объект.Родитель.ПринадлежитЭлементу(Справочники.КП_СписокМетаданных.Свойства)))
			Тогда
				Объект.ПолноеНаименование="СправочникСсылка.ЗначенияСвойствОбъектов";
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если  (ЗначениеЗаполнено(Объект.Родитель) 
		И (Объект.Родитель=Справочники.КП_СписокМетаданных.Свойства ИЛИ Объект.Родитель.ПринадлежитЭлементу(Справочники.КП_СписокМетаданных.Свойства)))
	Тогда
		СинхронизироватьСПланомВидовХарактеристик=Истина;
		ОбновитьСписокЗначенийСвойств();	
		
	КонецЕсли;
	
	УстановитьОтображениеЭлементов();	
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ СинхронизироватьСПланомВидовХарактеристик Тогда
		Возврат;
		
	КонецЕсли;
	
	//создадим или обновим при необходимости элемент плана видов характеристик
	НаименованиеСвойства=Объект.Наименование;
	
	Если ЗначениеЗаполнено(Объект.СвязьСПВХ) Тогда
		Если Объект.СвязьСПВХ.Наименование=НаименованиеСвойства Тогда
			//обновление наименования не требуется
			Возврат;
		КонецЕсли;
		
		ОбъектПВХ=Объект.СвязьСПВХ.ПолучитьОбъект();

	Иначе
		//новый объект
		
		НаименованиеГруппы="Свойства процессов";
		ГруппаПВХ=ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(НаименованиеГруппы);
		Если ГруппаПВХ=Неопределено ИЛИ ГруппаПВХ.Пустая() Тогда
			ГруппаПВХОбъект=ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьГруппу();
			ГруппаПВХОбъект.Наименование=НаименованиеГруппы;
			Попытка
				ГруппаПВХОбъект.Записать();
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
				Возврат;
			КонецПопытки;
			
			ГруппаПВХ=ГруппаПВХОбъект.Ссылка;
			
		КонецЕсли;
		
		ОбъектПВХ=ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьЭлемент();
		//ОбъектПВХ.Родитель=ГруппаПВХ;

	КонецЕсли;	
	
	ОбъектПВХ.Наименование=НаименованиеСвойства;
	//ОбъектПВХ.аПолноеНаименование=НаименованиеСвойства;
	
	Попытка
		ОбъектПВХ.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	Если НЕ ЗначениеЗаполнено(Объект.СвязьСПВХ) Тогда
		//если связь ещё не указана в объекте, укажем и запишем объект
		
		Объект.СвязьСПВХ=ОбъектПВХ.Ссылка;
		
		Попытка
			Записать();
			
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Возврат;
			
		КонецПопытки;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОбновитьСписокЗначенийСвойств();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтображениеЭлементов()
	
	ЭтоЭлементСвойств=(ЗначениеЗаполнено(Объект.Родитель) И (Объект.Родитель=Справочники.КП_СписокМетаданных.Свойства ИЛИ Объект.Родитель.ПринадлежитЭлементу(Справочники.КП_СписокМетаданных.Свойства)));
	Элементы.Наименование.ТолькоПросмотр=НЕ ЭтоЭлементСвойств;	
		
	Элементы.СписокЗначенийСвойства.Видимость=ЭтоЭлементСвойств;
	ОбновитьСписокЗначенийСвойств();
	
	Если Объект.Родитель=Справочники.КП_СписокМетаданных.Числа 
		ИЛИ Объект.Родитель=Справочники.КП_СписокМетаданных.Строки 
	Тогда
		Элементы.РеквизитДлина.Видимость=Истина;
		Элементы.Наименование.ТолькоПросмотр=Ложь;		
	КонецЕсли;
		
	Если Объект.Родитель=Справочники.КП_СписокМетаданных.Числа Тогда
		Элементы.РеквизитТочность.Видимость=Истина;		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если ПустаяСтрока(Объект.ПолноеНаименование) Тогда
		Объект.ПолноеНаименование=Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗначенийСвойстваПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("Оповещение_СписокЗначенийСвойстваПередНачаломДобавленияЗавершение", ЭтотОбъект), НСтр("ru='Сначала запишите свойство. Записать сейчас?'"), РежимДиалогаВопрос.ДаНет, , , КП_ОбщееКлиент.ЗаголовокДиалога());
		Отказ=Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Оповещение_СписокЗначенийСвойстваПередНачаломДобавленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса=КодВозвратаДиалога.Нет Тогда
        Возврат;
        
    КонецЕсли;
    
    Попытка
        Записать();
    Исключение
        ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
        Возврат;
        
    КонецПопытки;

КонецПроцедуры

Процедура ОбновитьСписокЗначенийСвойств()
	
	КП_ОбщееСервер.УстановитьОтборПоСписку(СписокЗначенийСвойства, "Владелец", Объект.СвязьСПВХ, , ВидСравненияКомпоновкиДанных.Равно);
	
КонецПроцедуры

#КонецОбласти
