
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("ВремяНачала") Тогда
		ВремяНачала = Параметры.ВремяНачала;
	КонецЕсли;
	Если Параметры.Свойство("ВремяОкончания") Тогда
		ВремяОкончания= Параметры.ВремяОкончания;
	КонецЕсли;
	Если Параметры.Свойство("Перерывы") Тогда
		Перерывы.Загрузить(Параметры.Перерывы.Выгрузить());
	КонецЕсли;
	Если Параметры.Свойство("ВремяПерерывов") Тогда
		ВремяПерерывов= Параметры.ВремяПерерывов;
	КонецЕсли;
	Если Параметры.Свойство("НомерДня") Тогда
		НомерДня = Параметры.НомерДня;
	КонецЕсли;
	Если Параметры.Свойство("ЧасовРаботы") Тогда
		ЧасовРаботыСУчетомПерерывов = Параметры.ЧасовРаботы;
	КонецЕсли;
	
	ЧасовРаботыИнтервал = ЧасовРаботыСУчетомПерерывов + ВремяПерерывов;
	
	Если (ЗначениеЗаполнено(ВремяНачала) ИЛИ ЗначениеЗаполнено(ВремяОкончания)) 
		ИЛИ ЗначениеЗаполнено(Параметры.ЧасовРаботы) Тогда
		
		СтрокаВремяНачала = ?(ЗначениеЗаполнено(ВремяНачала),Формат(ВремяНачала,"ДФ=HH:mm"), "00:00");
		СтрокаВремяОкончания = ?(ЗначениеЗаполнено(ВремяОкончания),Формат(ВремяОкончания,"ДФ=HH:mm"), "24:00");
		
		Элементы.НадписьРабочееВремя.Заголовок = "Рабочее время: " + СтрокаВремяНачала + "-" + СтрокаВремяОкончания;
		Элементы.ЧасовРаботыСУчетомПерерывов.ТолькоПросмотр = Истина;
	Иначе
		Элементы.НадписьРабочееВремя.Заголовок = "Рабочее время: <не указано>";
	КонецЕсли;
	
	Элементы.ВремяПерерывов.ТолькоПросмотр = Перерывы.Количество();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РасписаниеРаботыОкончаниеРабочегоДняПриИзменении(Элемент)
	
	ОбработатьИзменениеПериодаРабочегоДня(Ложь);
	ПроверитьГраницыПерерывовПриИзмниненииПериодаРабочегоДня(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура РасписаниеРаботыНачалоРабочегоДняПриИзменении(Элемент)
	
	ОбработатьИзменениеПериодаРабочегоДня();
	ПроверитьГраницыПерерывовПриИзмниненииПериодаРабочегоДня();
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяПерерывовПриИзменении(Элемент)
	
	ОбработкаИзмененияВремениПерерывов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерерывыВремяНачалаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Перерывы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	
	Если ЗначениеЗаполнено(ВремяНачала) И
		ТекущиеДанные.ВремяНачала < ВремяНачала Тогда
		ТекущиеДанные.ВремяНачала = ВремяНачала;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ВремяОкончания) И ТекущиеДанные.ВремяНачала >= ТекущиеДанные.ВремяОкончания Тогда
		ТекущиеДанные.ОшибкаПериода = Истина;
	Иначе
		ТекущиеДанные.ОшибкаПериода = Ложь;
	КонецЕсли;
	
	РасчитатьВремяПерерывовИСформироватьПредставлениеРасписания();
	
	ОшибкаВремениПерерывов = ?(ВремяПерерывов+ЧасовРаботыСУчетомПерерывов>ЧасовРаботыИнтервал, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерерывыВремяОкончанияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Перерывы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	
	
	Если ЗначениеЗаполнено(ВремяОкончания) И ТекущиеДанные.ВремяОкончания > ВремяОкончания Тогда
		ТекущиеДанные.ВремяОкончания = ВремяОкончания;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВремяНачала) И ЗначениеЗаполнено(ВремяОкончания)
		И ТекущиеДанные.ВремяОкончания < ВремяНачала Тогда
		ТекущиеДанные.ВремяОкончания = ВремяНачала;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ВремяНачала) И ЗначениеЗаполнено(ТекущиеДанные.ВремяОкончания) 
		И ТекущиеДанные.ВремяОкончания <= ТекущиеДанные.ВремяНачала Тогда
		ТекущиеДанные.ОшибкаПериода = Истина;
	Иначе
		ТекущиеДанные.ОшибкаПериода = Ложь;
	КонецЕсли;
	
	РасчитатьВремяПерерывовИСформироватьПредставлениеРасписания(Ложь);
	
	ОшибкаВремениПерерывов = ?(ВремяПерерывов+ЧасовРаботыСУчетомПерерывов>ЧасовРаботыИнтервал, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерерывыПриИзменении(Элемент)
	Элементы.ВремяПерерывов.ТолькоПросмотр = Перерывы.Количество();
КонецПроцедуры

&НаКлиенте
Процедура ПерерывыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элементы.Перерывы.ТекущиеДанные;
		ТекущиеДанные.НомерСтроки = Перерывы.Количество();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерерывыПослеУдаления(Элемент)
	Если Не Перерывы.Количество() Тогда
		ВремяПерерывов = 0;
		ЧасовРаботыСУчетомПерерывов = ЧасовРаботыИнтервал;
		Если ЗначениеЗаполнено(ВремяНачала) ИЛИ ЗначениеЗаполнено(ВремяОкончания) Тогда
			ОбработатьИзменениеПериодаРабочегоДня();
		КонецЕсли;
	КонецЕсли;
	
	ОшибкаВремениПерерывов = ?(ЧасовРаботыСУчетомПерерывов + ВремяПерерывов > ЧасовРаботыИнтервал, Истина, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ПерерывыПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.Перерывы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	
	ВремяПерерывов = ВремяПерерывов - ТекущиеДанные.Длительность;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВСправочник(Команда)
	
	Если Не ПроверитьГраницыПерерывов() Тогда Возврат КонецЕсли;
	
	Перерывы.Сортировать("ВремяНачала");
	
	Периоды.Очистить();
	
	ПоследнееВремяОкончанияПерерыва = Дата(1,1,1);
	КоличествоПерерывов = Перерывы.Количество();
	ИндексСтроки = 1;
	
	Если Не Перерывы.Количество()
		И (ЗначениеЗаполнено(ВремяНачала) ИЛИ ЗначениеЗаполнено(ВремяОкончания)) Тогда
		
		НоваяСтрока = Периоды.Добавить();
		НоваяСтрока.НомерДняЦикла = НомерДня;
		
		НоваяСтрока.ВремяНачала = ВремяНачала;
		НоваяСтрока.ВремяОкончания = ВремяОкончания;
		
	КонецЕсли;
	
	Для Каждого СтрокаПерерыва Из Перерывы Цикл
		
		Если ИндексСтроки = 1 Тогда
			
			НоваяСтрока = Периоды.Добавить();
			НоваяСтрока.НомерДняЦикла = НомерДня;
			
			НоваяСтрока.ВремяНачала = ВремяНачала;
			НоваяСтрока.ВремяОкончания = ?(ЗначениеЗаполнено(СтрокаПерерыва.ВремяНачала),СтрокаПерерыва.ВремяНачала, СтрокаПерерыва.ВремяОкончания);
			
			НоваяСтрока.Длительность = Окр((НоваяСтрока.ВремяОкончания - НоваяСтрока.ВремяНачала)/3600, 2, РежимОкругления.Окр15как20);
			
			// Если всего один перерыв
			Если ИндексСтроки = КоличествоПерерывов Тогда
				
				НоваяСтрока = Периоды.Добавить();
				НоваяСтрока.НомерДняЦикла = НомерДня;
				
				НоваяСтрока.ВремяНачала = СтрокаПерерыва.ВремяОкончания;
				НоваяСтрока.ВремяОкончания = ВремяОкончания;
				
				Длительность = Окр((НоваяСтрока.ВремяОкончания - НоваяСтрока.ВремяНачала)/3600, 2, РежимОкругления.Окр15как20);
				НоваяСтрока.Длительность = ?(Длительность < 0, 24 + Длительность, Длительность);
				
			КонецЕсли;
			
		ИначеЕсли ИндексСтроки = КоличествоПерерывов Тогда
			
			Если Не СтрокаПерерыва.ВремяНачала = ПоследнееВремяОкончанияПерерыва Тогда
				
				НоваяСтрока = Периоды.Добавить();
				НоваяСтрока.НомерДняЦикла = НомерДня;
				
				НоваяСтрока.ВремяНачала = ПоследнееВремяОкончанияПерерыва;
				НоваяСтрока.ВремяОкончания = СтрокаПерерыва.ВремяНачала;
				
				НоваяСтрока.Длительность = Окр((НоваяСтрока.ВремяОкончания - НоваяСтрока.ВремяНачала)/3600, 2, РежимОкругления.Окр15как20)
				
			КонецЕсли;
			
			НоваяСтрока = Периоды.Добавить();
			НоваяСтрока.НомерДняЦикла = НомерДня;
			
			НоваяСтрока.ВремяНачала = СтрокаПерерыва.ВремяОкончания;
			НоваяСтрока.ВремяОкончания = ВремяОкончания;
			
			Длительность = Окр((НоваяСтрока.ВремяОкончания - НоваяСтрока.ВремяНачала)/3600, 2, РежимОкругления.Окр15как20);
			НоваяСтрока.Длительность = ?(Длительность < 0, 24 + Длительность, Длительность);
			
		Иначе
			
			Если СтрокаПерерыва.ВремяНачала = ПоследнееВремяОкончанияПерерыва Тогда
				ПоследнееВремяОкончанияПерерыва = СтрокаПерерыва.ВремяОкончания;
				ИндексСтроки = ИндексСтроки + 1;
				Продолжить
			КонецЕсли;
			
			НоваяСтрока = Периоды.Добавить();
			НоваяСтрока.НомерДняЦикла = НомерДня;
			
			НоваяСтрока.ВремяНачала = ПоследнееВремяОкончанияПерерыва;
			НоваяСтрока.ВремяОкончания = СтрокаПерерыва.ВремяНачала;
			
			НоваяСтрока.Длительность = Окр((НоваяСтрока.ВремяОкончания - НоваяСтрока.ВремяНачала)/3600, 2, РежимОкругления.Окр15как20)
			
		КонецЕсли;
		
		ПоследнееВремяОкончанияПерерыва = СтрокаПерерыва.ВремяОкончания;
		ИндексСтроки = ИндексСтроки + 1;
		
	КонецЦикла;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ВремяНачала", ВремяНачала);
	ПараметрыЗакрытия.Вставить("ВремяОкончания", ВремяОкончания);
	ПараметрыЗакрытия.Вставить("ВремяПерерывов", ВремяПерерывов);
	ПараметрыЗакрытия.Вставить("Перерывы", Перерывы);
	ПараметрыЗакрытия.Вставить("Периоды", Периоды);
	ПараметрыЗакрытия.Вставить("ЧасыРаботы", ЧасовРаботыСУчетомПерерывов);
	
	ЭтаФорма.Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаИзмененияВремениПерерывов(ЭтоИзменениеПериодаВперерывах = Ложь)
	
	Если ЭтоИзменениеПериодаВперерывах И ВремяПерерывов > ЧасовРаботыИнтервал Тогда
		Возврат
	КонецЕсли;
	
	Если ВремяПерерывов>=24 Тогда
		ВремяПерерывов = ЧасовРаботыИнтервал - ЧасовРаботыСУчетомПерерывов;
		Возврат;
	КонецЕсли;
	
	Если ВремяПерерывов = 0 И ЧасовРаботыСУчетомПерерывов = 0 Тогда
		Возврат
	КонецЕсли;
	
	Если ЧасовРаботыИнтервал - ВремяПерерывов<0 Тогда
		
		ЧасовРаботыСУчетомПерерывов = ЧасовРаботыИнтервал + (ЧасовРаботыИнтервал - ВремяПерерывов);
		ВремяПерерывов = (ЧасовРаботыИнтервал - ВремяПерерывов) * -1;
		
		Возврат;
	ИначеЕсли ЧасовРаботыИнтервал - ВремяПерерывов = 0 Тогда
		ЧасовРаботыСУчетомПерерывов = ЧасовРаботыИнтервал;
		ВремяПерерывов = 0;
		Возврат;
		
	КонецЕсли;
	
	ЧасовРаботыСУчетомПерерывов = ЧасовРаботыИнтервал - ВремяПерерывов;
	ВремяПерерывов = ?(ЧасовРаботыИнтервал - ВремяПерерывов<0,0, ВремяПерерывов);
	
	ОшибкаВремениПерерывов = ?(ВремяПерерывов+ЧасовРаботыСУчетомПерерывов>ЧасовРаботыИнтервал, Истина, Ложь);
	
КонецПроцедуры


&НаСервере
Процедура УстановитьУсловноеОформление()

		НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
		РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Перерывы.ОшибкаПериода", Истина, ВидСравненияКомпоновкиДанных.Равно);
		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, "ПерерывыВремяНачала");
		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, "ПерерывыВремяОкончания");
		РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
		
		НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
		РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "ОшибкаВремениПерерывов", Истина, ВидСравненияКомпоновкиДанных.Равно);
		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, "ЧасовРаботыСУчетомПерерывов");
		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, "ВремяПерерывов");
		РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
		
		НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
		РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "ОшибкаВремениПериода", Истина, ВидСравненияКомпоновкиДанных.Равно);
		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, "РасписаниеРаботыНачалоРабочегоДня");
		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, "РасписаниеРаботыОкончаниеРабочегоДня");
		РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);

КонецПроцедуры

&НаКлиенте
Функция ПроверитьГраницыПерерывов()
	
	Если ЧасовРаботыСУчетомПерерывов = 0 Тогда
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Заполните часы работы.' ");
		Сообщение.Поле = "ЧасовРаботыСУчетомПерерывов";
		Сообщение.УстановитьДанные(ЭтаФорма);
		Сообщение.Сообщить();
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Если ВремяПерерывов + ЧасовРаботыСУчетомПерерывов > 24 Тогда
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Сумма перерывов и часов работы больше 24 часов.' ");
		Сообщение.Поле = "ЧасовРаботыСУчетомПерерывов";
		Сообщение.УстановитьДанные(ЭтаФорма);
		Сообщение.Сообщить();
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Если ОшибкаВремениПериода Тогда
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Начало и окончание рабочего дня не могут совпадать.' ");
		Сообщение.Поле = "ВремяОкончания";
		Сообщение.УстановитьДанные(ЭтаФорма);
		Сообщение.Сообщить();
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Для Каждого ПроверяемаяСтрока Из Перерывы Цикл
		
		ПроверяемаяСтрокаВремяОкончания = ?(Не ЗначениеЗаполнено(ПроверяемаяСтрока.ВремяОкончания), Дата(1,1,1,23,59,0), ПроверяемаяСтрока.ВремяОкончания);
		
		НомерТекущейСтроки = ПроверяемаяСтрока.НомерСтроки;
		
		Если ПроверяемаяСтрока.ОшибкаПериода 
			Или (Не ЗначениеЗаполнено(ПроверяемаяСтрока.ВремяНачала) И Не ЗначениеЗаполнено(ПроверяемаяСтрокаВремяОкончания)) Тогда
			
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Границы перерыва введены не верно.' ");
			Сообщение.Поле = "Перерывы[" + Строка(ПроверяемаяСтрока.НомерСтроки-1)+"]" + ".ВремяНачала";
			Сообщение.УстановитьДанные(ЭтаФорма);
			Сообщение.Сообщить();
			
			Возврат Ложь;
			
		КонецЕсли;
		
		Для Каждого СтрокаПерерывов Из Перерывы Цикл
			
			ПроверяемаяСтрокаВремяОкончания = ?(Не ЗначениеЗаполнено(ПроверяемаяСтрока.ВремяОкончания), Дата(1,1,1,23,59,0), ПроверяемаяСтрока.ВремяОкончания);
			СтрокаПерерывовВремяОкончания = ?(Не ЗначениеЗаполнено(СтрокаПерерывов.ВремяОкончания), Дата(1,1,1,23,59,0), СтрокаПерерывов.ВремяОкончания);
			
			// Проверка на поглащенные перерывы
			Если Не СтрокаПерерывов.НомерСтроки = НомерТекущейСтроки 
				И ЗначениеЗаполнено(ПроверяемаяСтрокаВремяОкончания) И ЗначениеЗаполнено(ПроверяемаяСтрока.ВремяНачала) Тогда
				
				Если ЗначениеЗаполнено(СтрокаПерерывовВремяОкончания) 
					И ПроверяемаяСтрокаВремяОкончания >= СтрокаПерерывовВремяОкончания
					И ПроверяемаяСтрока.ВремяНачала <= СтрокаПерерывов.ВремяНачала Тогда
					
					Сообщение = Новый СообщениеПользователю();
					Сообщение.Текст = НСтр("ru = 'Существует перерыв включенный в данный период.' ");
					Сообщение.Поле = "Перерывы[" + Строка(ПроверяемаяСтрока.НомерСтроки-1)+"]" + ".ВремяОкончания";
					Сообщение.УстановитьДанные(ЭтаФорма);
					Сообщение.Сообщить();
					Возврат Ложь;
				КонецЕсли;
				
				Если ПроверяемаяСтрокаВремяОкончания <= СтрокаПерерывовВремяОкончания
					И ПроверяемаяСтрока.ВремяНачала >= СтрокаПерерывов.ВремяНачала Тогда
					
					Сообщение = Новый СообщениеПользователю();
					Сообщение.Текст = НСтр("ru = 'Данный период включен в другой перерыв.' ");
					Сообщение.Поле = "Перерывы[" + Строка(ПроверяемаяСтрока.НомерСтроки-1)+"]" + ".ВремяОкончания";
					Сообщение.УстановитьДанные(ЭтаФорма);
					Сообщение.Сообщить();
					Возврат Ложь;
				КонецЕсли;
				
			КонецЕсли;
			// --------------
			
			Если Не СтрокаПерерывов.НомерСтроки = НомерТекущейСтроки И ЗначениеЗаполнено(ПроверяемаяСтрока.ВремяНачала)
				И (ПроверяемаяСтрока.ВремяНачала >= СтрокаПерерывов.ВремяНачала И ПроверяемаяСтрока.ВремяНачала < СтрокаПерерывовВремяОкончания) Тогда
				
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = НСтр("ru = 'Время окончания перерыва пересекается с периодом другого перерыва.' ");
				Сообщение.Поле = "Перерывы[" + Строка(ПроверяемаяСтрока.НомерСтроки-1)+"]" + ".ВремяОкончания";
				Сообщение.УстановитьДанные(ЭтаФорма);
				Сообщение.Сообщить();
				Возврат Ложь;
			КонецЕсли;
			
			Если Не СтрокаПерерывов.НомерСтроки = НомерТекущейСтроки И ЗначениеЗаполнено(ПроверяемаяСтрокаВремяОкончания)
				И (ПроверяемаяСтрокаВремяОкончания <= СтрокаПерерывовВремяОкончания И ПроверяемаяСтрокаВремяОкончания > СтрокаПерерывов.ВремяНачала) Тогда
				
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = НСтр("ru = 'Время начала перерыва пересекается с периодом другого перерыва.' ");
				Сообщение.Поле = "Перерывы[" + Строка(ПроверяемаяСтрока.НомерСтроки-1)+"]" + ".ВремяНачала";
				Сообщение.УстановитьДанные(ЭтаФорма);
				Сообщение.Сообщить();
				Возврат Ложь;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ВремяНачала) И Не ЗначениеЗаполнено(ПроверяемаяСтрока.ВремяНачала)Тогда
				
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = НСтр("ru = 'Задано начало раб. дня. Время начала перерыва не может быть пустым.' ");
				Сообщение.Поле = "Перерывы[" + Строка(ПроверяемаяСтрока.НомерСтроки-1)+"]" + ".ВремяНачала";
				Сообщение.УстановитьДанные(ЭтаФорма);
				Сообщение.Сообщить();
				Возврат Ложь;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ВремяОкончания) И Не ЗначениеЗаполнено(ПроверяемаяСтрокаВремяОкончания)Тогда
				
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = НСтр("ru = 'Задано окончание раб. дня. Время окончания перерыва не может быть пустым.' ");
				Сообщение.Поле = "Перерывы[" + Строка(ПроверяемаяСтрока.НомерСтроки-1)+"]" + ".ВремяОкончания";
				Сообщение.УстановитьДанные(ЭтаФорма);
				Сообщение.Сообщить();
				Возврат Ложь;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура РасчитатьВремяПерерывовИСформироватьПредставлениеРасписания(ЭтоВремяНачалаПерерыва = Истина)
	
	ТекущиеДанные = Элементы.Перерывы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	
	Если Перерывы.Количество() Тогда
		
		ИтогДлительностиПерерывов = 0;
		ИтогДлительностиПерерывовСек = 0;
		ИтогДлительностьПерерывовСек = 0;
		
		Для Каждого СтрокаПерерывов Из Перерывы Цикл
			
			Если СтрокаПерерывов.ВремяНачала < СтрокаПерерывов.ВремяОкончания
				Или (ЗначениеЗаполнено(СтрокаПерерывов.ВремяНачала) И Не ЗначениеЗаполнено(СтрокаПерерывов.ВремяОкончания)) Тогда
				
				ДлительностьПерерываСек = СтрокаПерерывов.ВремяОкончания - СтрокаПерерывов.ВремяНачала;
				ДлительностьПерерываСек = ?(ДлительностьПерерываСек > 0, ДлительностьПерерываСек, 86400 + ДлительностьПерерываСек);
				
				ДлительностьПерерыва = Окр(ДлительностьПерерываСек/3600, 2, РежимОкругления.Окр15как20);
				СтрокаПерерывов.Длительность = ?(ДлительностьПерерыва > 0, ДлительностьПерерыва, 24 + ДлительностьПерерыва);
				
				ИтогДлительностиПерерывов = ИтогДлительностиПерерывов + СтрокаПерерывов.Длительность;
				ИтогДлительностьПерерывовСек = ИтогДлительностьПерерывовСек + ДлительностьПерерываСек;
				
			КонецЕсли;
		КонецЦикла;
		ВремяПерерывов = ИтогДлительностиПерерывов;
		
	КонецЕсли;
	
	ОбработкаИзмененияВремениПерерывов(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеПериодаРабочегоДня(ЭтоВремяНачала = Истина)
	
	Если ЗначениеЗаполнено(ВремяНачала) И ЗначениеЗаполнено(ВремяОкончания) Тогда
		Если ВремяОкончания < ВремяНачала ИЛИ ВремяНачала > ВремяОкончания Тогда
			ВремяОкончания = ВремяНачала;
		КонецЕсли
	КонецЕсли;
		
	ЧасовРаботы = Окр((ВремяОкончания-ВремяНачала)/60/60, 2, РежимОкругления.Окр15как20);
	
	Если ЗначениеЗаполнено(ВремяНачала) Или ЗначениеЗаполнено(ВремяОкончания) Тогда
		ЧасовРаботы = ?(ЧасовРаботы > 0, ЧасовРаботы - ВремяПерерывов
		, 24 + ЧасовРаботы - ВремяПерерывов);
		
		Если ЧасовРаботы < 0 Тогда
			Если ЭтоВремяНачала Тогда
				ВремяНачала = ВремяНачала + (ЧасовРаботы*3600)
			Иначе
				ВремяОкончания = ВремяОкончания - (ЧасовРаботы*3600);
			КонецЕсли;
			
			ЧасовРаботы = 0;
		КонецЕсли;
	КонецЕсли;
	
	ЧасовРаботыСУчетомПерерывов = ЧасовРаботы;
	
	Если (ЗначениеЗаполнено(ВремяОкончания) ИЛИ ЗначениеЗаполнено(ВремяНачала))
		И ВремяНачала = ВремяОкончания Тогда
		ЧасовРаботыСУчетомПерерывов = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьГраницыПерерывовПриИзмниненииПериодаРабочегоДня(ЭтоВремяНачала = Истина)
	
	ОшибкаВремениПериода = ?(ЗначениеЗаполнено(ВремяОкончания) И ЗначениеЗаполнено(ВремяНачала)
	И ВремяОкончания = ВремяНачала, Истина, Ложь);
	
	Если (Не ЗначениеЗаполнено(ВремяНачала) И Не ЗначениеЗаполнено(ВремяОкончания))
		Или Не Перерывы.Количество() Тогда
		Возврат
	КонецЕсли;
	
	Если ЭтоВремяНачала И ЗначениеЗаполнено(ВремяНачала) Тогда
		
		НомерСтроки = 1;
		
		Для Каждого СтрокаПерерывов Из Перерывы Цикл
			
			Если ВремяНачала > СтрокаПерерывов.ВремяНачала Тогда
				
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = НСтр("ru = 'Время начала рабочего дня больше времени начала перерыва.' ");
				Сообщение.Поле = "Перерывы[" + Строка(НомерСтроки-1)+"]" + ".ВремяНачала";
				Сообщение.УстановитьДанные(ЭтаФорма);
				Сообщение.Сообщить();
				
				ВремяНачала = СтрокаПерерывов.ВремяНачала;
				
			КонецЕсли;
			
			НомерСтроки = НомерСтроки + 1;
			
		КонецЦикла;
	КонецЕсли;
	
	Если Не ЭтоВремяНачала И ЗначениеЗаполнено(ВремяОкончания) Тогда
		
		НомерСтроки = 1;
		
		Для Каждого СтрокаПерерывов Из Перерывы Цикл
			
			Если ВремяОкончания < СтрокаПерерывов.ВремяОкончания Тогда
				
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = НСтр("ru = 'Время окончания рабочего дня меньше времени окончания перерыва.' ");
				Сообщение.Поле = "Перерывы[" + Строка(НомерСтроки-1)+"]" + ".ВремяОкончания";
				Сообщение.УстановитьДанные(ЭтаФорма);
				Сообщение.Сообщить();
				
				ВремяОкончания = СтрокаПерерывов.ВремяОкончания; 
				
			КонецЕсли;
			
			НомерСтроки = НомерСтроки + 1;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

