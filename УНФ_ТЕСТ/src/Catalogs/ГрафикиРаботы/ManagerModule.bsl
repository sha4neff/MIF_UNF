#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура СозадьПредопреденныеШаблоныГрафиков() Экспорт

	НачатьТранзакцию();
	
	ГруппаШаблоновПоДнямНедели = Справочники.ШаблоныЗаполненияГрафиковРабочегоВремени.СоздатьГруппу();
	ГруппаШаблоновПоДнямНедели.Наименование = "Шаблоны по дням недели";
	
	ГруппаШаблоновСменные = Справочники.ШаблоныЗаполненияГрафиковРабочегоВремени.СоздатьГруппу();
	ГруппаШаблоновСменные.Наименование = "Шаблоны сменные";
	
	Попытка
		ГруппаШаблоновПоДнямНедели.Записать();
		ГруппаШаблоновСменные.Записать();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	// По дням Неделеи
	НовыйШаблонПятидневка = Справочники.ШаблоныЗаполненияГрафиковРабочегоВремени.СоздатьЭлемент();
	НовыйШаблонПятидневка.ОбменДанными.Загрузка = Истина;
	НовыйШаблонПятидневка.УчитыватьПраздничныеДни = Истина;
	НовыйШаблонПятидневка.Родитель = ГруппаШаблоновПоДнямНедели.Ссылка;
	НовыйШаблонПятидневка.Наименование = "Шаблон пятидневка";
	
	НовыйШаблонШестидневка = Справочники.ШаблоныЗаполненияГрафиковРабочегоВремени.СоздатьЭлемент();
	НовыйШаблонШестидневка.ОбменДанными.Загрузка = Истина;
	НовыйШаблонШестидневка.Родитель = ГруппаШаблоновПоДнямНедели.Ссылка;
	НовыйШаблонШестидневка.УчитыватьПраздничныеДни = Истина;
	НовыйШаблонШестидневка.Наименование = "Шаблон шестидневка";
	
	НовыйШаблонШестидневка.ВидГрафикаПоДнямНедели = Истина;
	НовыйШаблонШестидневка.ТипГрафика = Перечисления.ТипыГрафикаРаботы.КалендарныеДни;
	НовыйШаблонПятидневка.ВидГрафикаПоДнямНедели = Истина;
	НовыйШаблонПятидневка.ТипГрафика = Перечисления.ТипыГрафикаРаботы.КалендарныеДни;
		
	Для ИндексДня = 1 По 7 Цикл
		
		Если ИндексДня <= 5 Тогда
			НоваяСтрокаРасписания = НовыйШаблонПятидневка.РасписаниеРаботы.Добавить();
			
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.ВремяНачала = Дата(1,1,1,8,0,0);
			НоваяСтрокаРасписания.ВремяОкончания = Дата(1,1,1,17,0,0);
			НоваяСтрокаРасписания.КоличествоРабочихЧасов = 8;
			НоваяСтрокаРасписания.ВремяПерерывов = 1;
			НоваяСтрокаРасписания.Активность = Истина;
			
			НоваяСтрокаПерерыв = НовыйШаблонПятидневка.Перерывы.Добавить();
			НоваяСтрокаПерерыв.ВремяНачала = Дата(1,1,1,12,00,0);
			НоваяСтрокаПерерыв.ВремяОкончания = Дата(1,1,1,13,00,0);
			НоваяСтрокаПерерыв.Длительность = 1;
			НоваяСтрокаПерерыв.НомерДня = ИндексДня;
			
			НоваяСтрокаПериода = НовыйШаблонПятидневка.Периоды.Добавить();
			НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1,8,0,0);
			НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1,12,0,0);
			НоваяСтрокаПериода.Длительность = 4;
			НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
			
			НоваяСтрокаПериода = НовыйШаблонПятидневка.Периоды.Добавить();
			НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1,13,0,0);
			НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1,17,0,0);
			НоваяСтрокаПериода.Длительность = 4;
			НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
		
		Иначе
			НоваяСтрокаРасписания = НовыйШаблонПятидневка.РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.Активность = Истина
		КонецЕсли;
		
		Если ИндексДня <= 6 Тогда
			НоваяСтрокаРасписания = НовыйШаблонШестидневка.РасписаниеРаботы.Добавить();
			
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.ВремяНачала = Дата(1,1,1,8,0,0);
			НоваяСтрокаРасписания.ВремяОкончания = Дата(1,1,1,17,0,0);
			НоваяСтрокаРасписания.КоличествоРабочихЧасов = 8;
			НоваяСтрокаРасписания.ВремяПерерывов = 1;
			НоваяСтрокаРасписания.Активность = Истина;
			
			НоваяСтрокаПерерыв = НовыйШаблонШестидневка.Перерывы.Добавить();
			НоваяСтрокаПерерыв.ВремяНачала = Дата(1,1,1,12,00,0);
			НоваяСтрокаПерерыв.ВремяОкончания = Дата(1,1,1,13,00,0);
			НоваяСтрокаПерерыв.Длительность = 1;
			НоваяСтрокаПерерыв.НомерДня = ИндексДня;
			
			НоваяСтрокаПериода = НовыйШаблонШестидневка.Периоды.Добавить();
			НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1,8,0,0);
			НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1,12,0,0);
			НоваяСтрокаПериода.Длительность = 4;
			НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
			
			НоваяСтрокаПериода = НовыйШаблонШестидневка.Периоды.Добавить();
			НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1,13,0,0);
			НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1,17,0,0);
			НоваяСтрокаПериода.Длительность = 4;
			НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
		Иначе
			НоваяСтрокаРасписания = НовыйШаблонШестидневка.РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.Активность = Истина
		КонецЕсли;
		
	КонецЦикла;
	
	//Сменные
	НовыйШаблонСменный2через2_12 = Справочники.ШаблоныЗаполненияГрафиковРабочегоВремени.СоздатьЭлемент();
	НовыйШаблонСменный2через2_12.ОбменДанными.Загрузка = Истина;
	НовыйШаблонСменный2через2_12.Родитель = ГруппаШаблоновСменные.Ссылка;
	НовыйШаблонСменный2через2_12.Наименование = "Шаблон сменный 12 часов 2 через 2 ";
	
	НовыйШаблонЖД = Справочники.ШаблоныЗаполненияГрафиковРабочегоВремени.СоздатьЭлемент();
	НовыйШаблонЖД.ОбменДанными.Загрузка = Истина;
	НовыйШаблонЖД.Родитель = ГруппаШаблоновСменные.Ссылка;
	НовыйШаблонЖД.Наименование = "Шаблон сменный 3 через 1 (железнодорожный)";
	
	НовыйШаблонСменныйСуткиТрое = Справочники.ШаблоныЗаполненияГрафиковРабочегоВремени.СоздатьЭлемент();
	НовыйШаблонСменныйСуткиТрое.ОбменДанными.Загрузка = Истина;
	НовыйШаблонСменныйСуткиТрое.Родитель = ГруппаШаблоновСменные.Ссылка;
	НовыйШаблонСменныйСуткиТрое.Наименование = "Шаблон сменный сутки через трое ";
	
	НовыйШаблонЖД.ВидГрафикаПоЦикламПроизвольнойДлины = Истина;
	НовыйШаблонСменный2через2_12.ВидГрафикаПоЦикламПроизвольнойДлины = Истина;
	НовыйШаблонСменныйСуткиТрое.ВидГрафикаПоЦикламПроизвольнойДлины = Истина;
	
	НовыйШаблонСменный2через2_12.ТипГрафика = Перечисления.ТипыГрафикаРаботы.Сменный;
	НовыйШаблонЖД.ТипГрафика = Перечисления.ТипыГрафикаРаботы.Сменный;
	НовыйШаблонСменныйСуткиТрое.ТипГрафика = Перечисления.ТипыГрафикаРаботы.Сменный;
	
	
	Для ИндексДня = 1 По 4 Цикл
		
		Если ИндексДня <= 2 Тогда
			НоваяСтрокаРасписания = НовыйШаблонСменный2через2_12.РасписаниеРаботы.Добавить();
			
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.КоличествоРабочихЧасов = 12;
			НоваяСтрокаРасписания.Активность = Истина;
			
			НоваяСтрокаПериода = НовыйШаблонСменный2через2_12.Периоды.Добавить();
			НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1);
			НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1);
			НоваяСтрокаПериода.Длительность = 12;
			НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
		
		Иначе
			НоваяСтрокаРасписания = НовыйШаблонСменный2через2_12.РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.Активность = Ложь;
		КонецЕсли;
		
		Если ИндексДня <= 3 Тогда
			НоваяСтрокаРасписания = НовыйШаблонЖД.РасписаниеРаботы.Добавить();
			
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			
			Если ИндексДня = 1 Тогда
				НоваяСтрокаРасписания.КоличествоРабочихЧасов = 12;
				
				НоваяСтрокаПериода = НовыйШаблонЖД.Периоды.Добавить();
				НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1);
				НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1);
				НоваяСтрокаПериода.Длительность = 12;
				НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
				
			ИначеЕсли ИндексДня = 2 Тогда
				НоваяСтрокаРасписания.КоличествоРабочихЧасов = 4;
				НоваяСтрокаПериода = НовыйШаблонЖД.Периоды.Добавить();
				
				НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1);
				НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1);
				НоваяСтрокаПериода.Длительность = 4;
				НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
			ИначеЕсли ИндексДня = 3 Тогда
				НоваяСтрокаРасписания.КоличествоРабочихЧасов = 8;
				
				НоваяСтрокаПериода = НовыйШаблонЖД.Периоды.Добавить();
				НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1);
				НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1);
				НоваяСтрокаПериода.Длительность = 8;
				НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
			КонецЕсли;
			
			НоваяСтрокаРасписания.Активность = Истина;
		Иначе
			НоваяСтрокаРасписания = НовыйШаблонЖД.РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.Активность = Ложь
		КонецЕсли;
		
		Если ИндексДня = 1 Тогда
			НоваяСтрокаРасписания = НовыйШаблонСменныйСуткиТрое.РасписаниеРаботы.Добавить();
			
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.КоличествоРабочихЧасов = 24;
			
			НоваяСтрокаПериода = НовыйШаблонСменныйСуткиТрое.Периоды.Добавить();
			НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1);
			НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1);
			НоваяСтрокаПериода.Длительность = 24;
			НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
			
			НоваяСтрокаРасписания.Активность = Истина;
		Иначе
			НоваяСтрокаРасписания = НовыйШаблонСменныйСуткиТрое.РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.Активность = Ложь
		КонецЕсли;
		
	КонецЦикла;
	
	Попытка
		НовыйШаблонПятидневка.Записать();
		НовыйШаблонШестидневка.Записать();
		НовыйШаблонСменный2через2_12.Записать();
		НовыйШаблонЖД.Записать();
		НовыйШаблонСменныйСуткиТрое.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

Процедура ОбновитьГрафикиУчетаРабочегоВремени() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГрафикиРаботы.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТГрафики
	|ИЗ
	|	Справочник.ГрафикиРаботы КАК ГрафикиРаботы
	|
	|СГРУППИРОВАТЬ ПО
	|	ГрафикиРаботы.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ГрафикиРаботы.УдалитьПериоды.ВремяНачала) > 1
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГрафикиРаботы.Ссылка
	|ИЗ
	|	Справочник.ГрафикиРаботы КАК ГрафикиРаботы
	|ГДЕ
	|	НЕ ГрафикиРаботы.УдалитьКалендарь = ЗНАЧЕНИЕ(Справочник.Календари.ПУстаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТГрафики.Ссылка КАК Ссылка
	|ИЗ
	|	ВТГрафики КАК ВТГрафики
	|ГДЕ
	|	НЕ ВТГрафики.Ссылка.УдалитьТипГрафика = ЗНАЧЕНИЕ(Перечисление.ТипыГрафикаРаботы.пустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТГрафики.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ВТГрафики.Ссылка.ШаблоныПоГоду.Ссылка) = 0";
	
	
	ВыборкаГрафиков = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаГрафиков.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(ВыборкаГрафиков.Ссылка.УдалитьТипГрафика) Тогда Продолжить КонецЕсли;
		
		КоличествоПериодов = ВыборкаГрафиков.Ссылка.УдалитьПериоды.Количество();
		
		ПериодыПустые = Истина;
		
		Для Каждого СтрокаПериода Из ВыборкаГрафиков.Ссылка.УдалитьПериоды Цикл
			
			Если ЗначениеЗаполнено(СтрокаПериода.ВремяНачала) ИЛИ ЗначениеЗаполнено(СтрокаПериода.ВремяОкончания) Тогда
				ПериодыПустые = Ложь;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		НачатьТранзакцию();
		
		ОбъектВыборки = ВыборкаГрафиков.Ссылка.ПолучитьОбъект();
		ОбъектВыборки.ОбменДанными.Загрузка = Истина;
		
		Если ЗначениеЗаполнено(ОбъектВыборки.УдалитьКалендарь) И ЗначениеЗаполнено(ОбъектВыборки.УдалитьКалендарь.ПроизводственныйКалендарь)
			Тогда
			ОбъектВыборки.ПроизводственныйКалендарь = ОбъектВыборки.УдалитьКалендарь.ПроизводственныйКалендарь;
		КонецЕсли;
		
		Если КоличествоПериодов И Не ПериодыПустые Тогда
		
		НовыйШаблон = Справочники.ШаблоныЗаполненияГрафиковРабочегоВремени.СоздатьЭлемент();
		НовыйШаблон.Наименование = "Шаблон "+ОбъектВыборки.Наименование;
		
		ЭтоНедельныйГрафик = Ложь;
		
		Если ОбъектВыборки.УдалитьТипГрафика = Перечисления.ТипыГрафикаРаботы.Пятидневка
			ИЛИ ОбъектВыборки.УдалитьТипГрафика = Перечисления.ТипыГрафикаРаботы.Шестидневка
			ИЛИ ОбъектВыборки.УдалитьТипГрафика = Перечисления.ТипыГрафикаРаботы.КалендарныеДни
			Тогда
			НовыйШаблон.ТипГрафика = Перечисления.ТипыГрафикаРаботы.КалендарныеДни;
			ЭтоНедельныйГрафик = Истина;
		Иначе
			НовыйШаблон.ТипГрафика = Перечисления.ТипыГрафикаРаботы.Сменный;
		КонецЕсли;
		
		ОбъектВыборки.УдалитьПериоды.Сортировать("НомерДня Возр, ВремяНачала Возр");
		
		Если ЭтоНедельныйГрафик Тогда
			ПоследнийДеньПериодов = 7;
		Иначе
			ПоследнийДеньПериодов = ОбъектВыборки.УдалитьПериоды[КоличествоПериодов-1].НомерДня;
		КонецЕсли;
		
		Для НомерДня = 1 По ПоследнийДеньПериодов Цикл
			
			ПараметрыОтбора = Новый Структура("НомерДня", НомерДня);
			СтрокиПоДню = ОбъектВыборки.УдалитьПериоды.НайтиСтроки(ПараметрыОтбора);
			
			Если Не СтрокиПоДню.Количество() Тогда
				
				Если ЭтоНедельныйГрафик Тогда
					СтрокаШаблона = НовыйШаблон.РасписаниеРаботы.Добавить();
					СтрокаШаблона.НомерДняЦикла = НомерДня;
					Продолжить;
				Иначе
					Прервать
				КонецЕсли;
				
			КонецЕсли;
			
			СтрокаШаблона = НовыйШаблон.РасписаниеРаботы.Добавить();
			СтрокаШаблона.ВремяНачала = СтрокиПоДню[0].ВремяНачала;
			СтрокаШаблона.НомерДняЦикла = НомерДня;
			
			ДлительностьПериодов = 0;
			
			//Периоды Шаблона
			Для Каждого СтрокаПериод Из СтрокиПоДню Цикл
				
				СтрокаПериодШаблона = НовыйШаблон.Периоды.Добавить();
				СтрокаПериодШаблона.ВремяНачала = СтрокаПериод.ВремяНачала;
				СтрокаПериодШаблона.ВремяОкончания = ?(СтрокаПериод.ВремяОкончания = КонецДня(СтрокаПериод.ВремяОкончания)
				, НачалоДня(СтрокаПериод.ВремяОкончания), СтрокаПериод.ВремяОкончания);
				
				СтрокаПериодШаблона.НомерДняЦикла = НомерДня;
				
				Длительность = Окр((СтрокаПериодШаблона.ВремяОкончания - СтрокаПериодШаблона.ВремяНачала)/3600, 2, РежимОкругления.Окр15как20);
				СтрокаПериодШаблона.Длительность = ?(Длительность < 0, 24 + Длительность, Длительность);
				
				ДлительностьПериодов = ДлительностьПериодов + СтрокаПериодШаблона.Длительность;
				
			КонецЦикла;
			// Конец Перерывы Шаблона
			
			СтрокаШаблона.ВремяОкончания = СтрокаПериодШаблона.ВремяОкончания;
			
			СтрокаШаблона.Активность = ?(ЗначениеЗаполнено(СтрокаШаблона.ВремяНачала) ИЛИ ЗначениеЗаполнено(СтрокаПериодШаблона.ВремяОкончания), Истина, Ложь);
			
			//Перерывы Шаблона
			ПоследнееВремяОкончанияПерерыва = Дата(1,1,1);
			
			ПараметрыОтбора = Новый Структура("НомерДняЦикла", НомерДня);
			Периоды = НовыйШаблон.Периоды.НайтиСтроки(ПараметрыОтбора);
			
			КоличествоПериодов = НовыйШаблон.Периоды.Количество();
			ИндексСтроки = 1;
			
			ДлительностьПерерывов = 0;
			ВремяНачалаПерерыва = Дата(1,1,1);
			
			Для Каждого СтрокаПериода Из Периоды Цикл
				
				Если КоличествоПериодов = 1 Тогда Прервать КонецЕсли;
				
				Если ИндексСтроки = 1 Тогда
					
					ВремяНачалаПерерыва = СтрокаПериода.ВремяОкончания;
				Иначе
					
					НоваяСтрока = НовыйШаблон.Перерывы.Добавить();
					НоваяСтрока.НомерДня = НомерДня;
					
					НоваяСтрока.ВремяНачала = ВремяНачалаПерерыва;
					НоваяСтрока.ВремяОкончания = СтрокаПериода.ВремяНачала;
					
					ВремяНачалаПерерыва = СтрокаПериода.ВремяОкончания;
					
					НоваяСтрока.Длительность = Окр((НоваяСтрока.ВремяОкончания - НоваяСтрока.ВремяНачала)/3600, 2, РежимОкругления.Окр15как20);
					
					ДлительностьПерерывов = ДлительностьПерерывов + НоваяСтрока.Длительность;
					
				КонецЕсли;
				
				ИндексСтроки = ИндексСтроки + 1;
				
			КонецЦикла;
			// Конец Перерывы Шаблона
			
			СтрокаШаблона.КоличествоРабочихЧасов = ДлительностьПериодов;
			СтрокаШаблона.ВремяПерерывов = ДлительностьПерерывов;
			
		КонецЦикла;
		
		ОбъектВыборки.ПериодыГрафика.Очистить();
		ОбъектВыборки.Перерывы.Очистить();
		ОбъектВыборки.РасписаниеРаботы.Очистить();
		ОбъектВыборки.УдалитьПериоды.Очистить();
		
		ОбъектВыборки.ПериодыГрафика.Загрузить(НовыйШаблон.Периоды.Выгрузить());
		ОбъектВыборки.Перерывы.Загрузить(НовыйШаблон.Перерывы.Выгрузить());
		ОбъектВыборки.РасписаниеРаботы.Загрузить(НовыйШаблон.РасписаниеРаботы.Выгрузить());
		
		ЭтоГрафикПоДнямНедели = ?(НовыйШаблон.ТипГрафика = Перечисления.ТипыГрафикаРаботы.КалендарныеДни, Истина, Ложь);
		
		Попытка
			НовыйШаблон.Записать();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ГрафикРаботы", ВыборкаГрафиков.Ссылка);
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ГрафикиРаботы.Год КАК Год
		|ИЗ
		|	РегистрСведений.ГрафикиРаботы КАК ГрафикиРаботы
		|ГДЕ
		|	ГрафикиРаботы.ГрафикРаботы = &ГрафикРаботы
		|
		|УПОРЯДОЧИТЬ ПО
		|	Год";
		
		ВыборкаГода = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаГода.Следующий() Цикл
			
			НоваяСтрока = ОбъектВыборки.ШаблоныПоГоду.Добавить();
			НоваяСтрока.Год = ВыборкаГода.Год;
			НоваяСтрока.ШаблонЗаполненияГрафика = ?(Не НовыйШаблон = Неопределено, НовыйШаблон.Ссылка, Неопределено);
			НоваяСтрока.ТипГрафика =  ?(Не НовыйШаблон = Неопределено, НовыйШаблон.ТипГрафика, Неопределено);
			НоваяСтрока.ДатаОтсчета = ?(Год(ВыборкаГрафиков.Ссылка.УдалитьДатаОтсчета) = НоваяСтрока.Год, ВыборкаГрафиков.Ссылка.УдалитьДатаОтсчета, Дата(1,1,1));
			
			// Обработка регистра сведений
			НаборЗаписей = РегистрыСведений.ГрафикиРаботы.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ГрафикРаботы.Установить(ВыборкаГрафиков.Ссылка);
			НаборЗаписей.Отбор.Год.Установить(ВыборкаГода.Год);
			НаборЗаписей.Прочитать();
			
				Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
					
					РазностьВремени = ЗаписьНабора.ВремяОкончания - ЗаписьНабора.ВремяНачала;
					РазностьВремени = ?(РазностьВремени = 86399, 86400, РазностьВремени);
					
					Длительность = Окр((РазностьВремени)/3600, 2, РежимОкругления.Окр15как20);
					ЗаписьНабора.ЧасыРаботы = ?(Длительность < 0, 24 + Длительность, Длительность);
					
				КонецЦикла;
			
			Попытка
				НаборЗаписей.Записать();
			Исключение
				ОтменитьТранзакцию();
				ВызватьИсключение;
			КонецПопытки;
			
		КонецЦикла;
		
		Попытка
			ОбъектВыборки.Записать();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;
	
	// Обработка регистра сведений "Отклонения от графиков работы"
	НаборЗаписей = РегистрыСведений.ОтклоненияОтГрафиковРаботыРесурсов.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	
	Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
		
		РазностьВремени = ЗаписьНабора.ВремяОкончания - ЗаписьНабора.ВремяНачала;
		РазностьВремени = ?(РазностьВремени = 86399, 86400, РазностьВремени);
		
		Длительность = Окр((РазностьВремени)/3600, 2, РежимОкругления.Окр15как20);
		ЗаписьНабора.ЧасыРаботы = ?(Длительность < 0, 24 + Длительность, Длительность);
		
	КонецЦикла;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗаполнитьДаннымиПроизводстенногоКалендаря(ДанныеГрафика, НомерТекущегоГода, ОбновитьКалендарь = Ложь,
	БезКалендаря = Ложь, ПриОткрытииФормы = Ложь, ДатаОтсчета, ТипГрафика, ИзмененныеДни = Неопределено, ОбъектЗаполнения) Экспорт
	
	Если Не ЗначениеЗаполнено(ОбъектЗаполнения.ПроизводственныйКалендарь) И Не БезКалендаря Тогда Возврат КонецЕсли;
	
	УчитыватьПраздники = ОбъектЗаполнения.УчитыватьПраздничныеДни;
	
	ЭтоГрафикПоДнямНедели = ?(ТипГрафика = Перечисления.ТипыГрафикаРаботы.КалендарныеДни, Истина, Ложь);
	
	Если Не БезКалендаря Тогда
		ДанныеКалендаря = ДанныеПроизводственногоКалендаря(ОбъектЗаполнения.ПроизводственныйКалендарь, НомерТекущегоГода);
		Если Не ДанныеКалендаря.Количество() Тогда Возврат КонецЕсли;
	КонецЕсли;
	
	ГрафикПустой = Не ДанныеГрафика.Количество();
	
	Если ЭтоГрафикПоДнямНедели ИЛИ ОбновитьКалендарь
		ИЛИ ПриОткрытииФормы ИЛИ БезКалендаря Тогда
		
		Для СчетчикМесяц = 1 По 12 Цикл
			
			Если ОбновитьКалендарь И Не ГрафикПустой Тогда
				СтрокаКалендаря = ДанныеГрафика[СчетчикМесяц-1];
			Иначе
				СтрокаКалендаря = ДанныеГрафика.Добавить();
			КонецЕсли;
			
			СтрокаКалендаря.НомерМесяца = СчетчикМесяц;
			
			СтрокаКалендаря.КоличествоДнейВМесяце = День(КонецМесяца(Дата(НомерТекущегоГода,СчетчикМесяц, 1)));
			
			РабочиеЧасыЗаМесяц = 0;
			
			Для НомерДня = 1 По СтрокаКалендаря.КоличествоДнейВМесяце Цикл
				
				НомерДняСтрокой = Строка(НомерДня); 
				
				ИмяПоляДень = "День" + НомерДняСтрокой;
				ИмяПоляВидДня = "ВидДня"+НомерДняСтрокой;
				ИмяПоляДеньЦикла = "НомерДняЦикла"+НомерДняСтрокой;
				
				Если БезКалендаря Тогда
					СтрокаКалендаря[ИмяПоляВидДня] = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий;
					Продолжить
				КонецЕсли;
				
				ДатаДня = Дата(НомерТекущегоГода, СчетчикМесяц, НомерДня);
				
				ПараметрыОтбора = Новый Структура("Дата", ДатаДня);
				
				СтрокиПрКалендаря = ДанныеКалендаря.НайтиСтроки(ПараметрыОтбора);
				
				СтрокаПрКалендаря = СтрокиПрКалендаря[0];
				
				Если ОбновитьКалендарь Тогда
					СтрокаКалендаря[ИмяПоляВидДня] = СтрокаПрКалендаря.ВидДня;
					Продолжить;
				КонецЕсли;
				
				НомерДняЦикла = ДеньНедели(СтрокаПрКалендаря.Дата);
				
				ПараметрыОтбора = Новый Структура("НомерДняЦикла", НомерДняЦикла);
				
				ЧасыРаботыПоДню = ОбъектЗаполнения.РасписаниеРаботы.НайтиСтроки(ПараметрыОтбора);
				
				КоличествоРабочихЧасов = ВремяДняПоДопНастройкам(ДатаДня, СтрокаПрКалендаря.ВидДня, ИзмененныеДни, ОбъектЗаполнения, СтрокаПрКалендаря.ДатаПереноса);
				
				Если (Не ЧасыРаботыПоДню.Количество() И КоличествоРабочихЧасов = 0)
					ИЛИ (ОбъектЗаполнения.УчитыватьПраздничныеДни И (СтрокаПрКалендаря.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник 
					ИЛИ (Не СтрокаПрКалендаря.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный И ЗначениеЗаполнено(СтрокаПрКалендаря.ДатаПереноса))))Тогда
					СтрокаКалендаря[ИмяПоляВидДня] = СтрокаПрКалендаря.ВидДня;
					Продолжить;
				КонецЕсли;
					
				СтрокаКалендаря["Изменен"+НомерДняСтрокой] = ?(Не КоличествоРабочихЧасов = 0, Истина, Ложь);
				
				Если КоличествоРабочихЧасов = 0 Тогда
					КоличествоРабочихЧасов = ЧасыРаботыПоДню[0].КоличествоРабочихЧасов;
				КонецЕсли;
				
				СтрокаКалендаря[ИмяПоляВидДня] = СтрокаПрКалендаря.ВидДня;
				СтрокаКалендаря[ИмяПоляДень] = КоличествоРабочихЧасов;
				СтрокаКалендаря[ИмяПоляДеньЦикла] = НомерДняЦикла;
				
				РабочиеЧасыЗаМесяц = РабочиеЧасыЗаМесяц + КоличествоРабочихЧасов;
				
				Если СтрокаПрКалендаря.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный
					ИЛИ СтрокаПрКалендаря.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий Тогда
					
					СтрокаКалендаря[ИмяПоляВидДня] = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий;
					
				КонецЕсли;
				
			КонецЦикла;
			
			РабочиеЧасыЗаМесяц = Окр(РабочиеЧасыЗаМесяц, 2, РежимОкругления.Окр15как20);
			
			Если ПриОткрытииФормы Тогда
				СтрокаКалендаря.ДнейЧасовПредставление = Строка(СтрокаКалендаря.КоличествоДнейВМесяце) + " / " + Строка(РабочиеЧасыЗаМесяц);
				СтрокаКалендаря.ИтогДни = СтрокаКалендаря.КоличествоДнейВМесяце;
				СтрокаКалендаря.МесяцПредставление = ПолучитьМесяцПоНомеру(СчетчикМесяц);
				Продолжить
			КонецЕсли;
				
			Если ОбновитьКалендарь Тогда Продолжить;
			КонецЕсли;
				
			СтрокаКалендаря.МесяцПредставление = ПолучитьМесяцПоНомеру(СчетчикМесяц);
			
			СтрокаКалендаря.ДнейЧасовПредставление = Строка(СтрокаКалендаря.КоличествоДнейВМесяце) + " / " + Строка(РабочиеЧасыЗаМесяц);
			СтрокаКалендаря.ИтогДни = СтрокаКалендаря.КоличествоДнейВМесяце;
			СтрокаКалендаря.ИтогЧасы = РабочиеЧасыЗаМесяц;
			
		КонецЦикла;
		
	Иначе
		
		КоличествоПосменныхДней = ОбъектЗаполнения.РасписаниеРаботы.Количество();
		
		Если КоличествоПосменныхДней = 0 Тогда Возврат КонецЕсли;
		
		ИндексДняПосменныхДней = 1;
		
		Для СчетчикМесяц = 1 По 12 Цикл
			
			СтрокаКалендаря = ДанныеГрафика.Добавить();
			
			СтрокаКалендаря.НомерМесяца = СчетчикМесяц;
			
			СтрокаКалендаря.КоличествоДнейВМесяце = День(КонецМесяца(Дата(НомерТекущегоГода,СчетчикМесяц, 1)));
			
			РабочиеЧасыЗаМесяц = 0;
			
			Для НомерДня = 1 По СтрокаКалендаря.КоличествоДнейВМесяце Цикл
				
				НомерДняСтрокой = Строка(НомерДня);
				
				ИмяПоляДень = "День" + НомерДняСтрокой;
				ИмяПоляВидДня = "ВидДня"+НомерДняСтрокой;
				ИмяПоляДеньЦикла = "НомерДняЦикла"+НомерДняСтрокой;
				
				ДатаДня = Дата(НомерТекущегоГода, СчетчикМесяц, НомерДня);
				
				ПараметрыОтбора = Новый Структура("Дата", ДатаДня);
				
				СтрокиПрКалендаря = ДанныеКалендаря.НайтиСтроки(ПараметрыОтбора);
				
				СтрокаПрКалендаря = СтрокиПрКалендаря[0];
				
				СтрокаКалендаря[ИмяПоляВидДня] = СтрокаПрКалендаря.ВидДня;
				
				Если ДатаДня < ДатаОтсчета Тогда Продолжить КонецЕсли;
				
				СтрокаКалендаря[ИмяПоляДеньЦикла] = ИндексДняПосменныхДней;
				
				ПараметрыОтбора = Новый Структура("НомерДняЦикла, Активность", ИндексДняПосменныхДней, Истина);
				
				ИндексДняПосменныхДней = ?(ИндексДняПосменныхДней = КоличествоПосменныхДней, 1, ИндексДняПосменныхДней + 1);
				
				ЧасыРаботыПоДню = ОбъектЗаполнения.РасписаниеРаботы.НайтиСтроки(ПараметрыОтбора);
				
				КоличествоРабочихЧасов = ВремяДняПоДопНастройкам(ДатаДня, СтрокаПрКалендаря.ВидДня, ИзмененныеДни, ОбъектЗаполнения, СтрокаПрКалендаря.ДатаПереноса);
				
				Если (Не ЧасыРаботыПоДню.Количество() И КоличествоРабочихЧасов = 0)
					ИЛИ (ОбъектЗаполнения.УчитыватьПраздничныеДни И (СтрокаПрКалендаря.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник 
					ИЛИ (Не СтрокаПрКалендаря.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный И ЗначениеЗаполнено(СтрокаПрКалендаря.ДатаПереноса))))Тогда
					СтрокаКалендаря[ИмяПоляВидДня] = СтрокаПрКалендаря.ВидДня;
					Продолжить;
				КонецЕсли;
					
				СтрокаКалендаря["Изменен"+НомерДняСтрокой] = ?(Не КоличествоРабочихЧасов = 0, Истина, Ложь);
				
				Если КоличествоРабочихЧасов = 0 Тогда
					КоличествоРабочихЧасов = ЧасыРаботыПоДню[0].КоличествоРабочихЧасов;
				КонецЕсли;
					
				СтрокаКалендаря[ИмяПоляДень] = КоличествоРабочихЧасов;
				
				РабочиеЧасыЗаМесяц = РабочиеЧасыЗаМесяц + КоличествоРабочихЧасов;
				
			КонецЦикла;
			
			РабочиеЧасыЗаМесяц = Окр(РабочиеЧасыЗаМесяц, 2, РежимОкругления.Окр15как20);
			
			СтрокаКалендаря.МесяцПредставление = ПолучитьМесяцПоНомеру(СчетчикМесяц);
			СтрокаКалендаря.ДнейЧасовПредставление = Строка(СтрокаКалендаря.КоличествоДнейВМесяце) + " / " + Строка(РабочиеЧасыЗаМесяц);
			СтрокаКалендаря.ИтогДни = СтрокаКалендаря.КоличествоДнейВМесяце;
			СтрокаКалендаря.ИтогЧасы = РабочиеЧасыЗаМесяц;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВремяДняПоДопНастройкам(ДатаДня, ВидДня, ИзмененныеДни, ОбъектЗаполнения, ДатаПереноса = Неопределено)
	
	Для Каждого ДопНастройка Из ОбъектЗаполнения.ДополнительныеНастройкиЗаполнения Цикл
		
		Если ЗначениеЗаполнено(ДопНастройка.ЗначениеНастройки) Тогда
			
			Если ДопНастройка.ЗначениеНастройки = "По четным числам" И День(ДатаДня)%2 = 0 Тогда
				Если Не ДопНастройка.КоличествоРабочихЧасов = 0 Тогда
					ЗаполнитьПериодыПоДопНастройкам(ИзмененныеДни,ДатаДня, ДопНастройка.ЗначениеНастройки, ОбъектЗаполнения);
				КонецЕсли;
				Возврат ДопНастройка.КоличествоРабочихЧасов;
			КонецЕсли;
			
			Если ДопНастройка.ЗначениеНастройки = "По нечетным числам" И Не День(ДатаДня)%2 = 0 Тогда
				Если Не ДопНастройка.КоличествоРабочихЧасов = 0 Тогда
					ЗаполнитьПериодыПоДопНастройкам(ИзмененныеДни,ДатаДня, ДопНастройка.ЗначениеНастройки, ОбъектЗаполнения);
				КонецЕсли;
				Возврат ДопНастройка.КоличествоРабочихЧасов;
			КонецЕсли;
			
			Если ДопНастройка.ЗначениеНастройки = "По субботам" И ДеньНедели(ДатаДня) = 6 Тогда
				Если Не ДопНастройка.КоличествоРабочихЧасов = 0 Тогда
					ЗаполнитьПериодыПоДопНастройкам(ИзмененныеДни,ДатаДня, ДопНастройка.ЗначениеНастройки, ОбъектЗаполнения);
				КонецЕсли;
				Возврат ДопНастройка.КоличествоРабочихЧасов;
			КонецЕсли;
			
			Если ДопНастройка.ЗначениеНастройки = "По воскресеньям" И ДеньНедели(ДатаДня) = 7 Тогда
				Если Не ДопНастройка.КоличествоРабочихЧасов = 0 Тогда
					ЗаполнитьПериодыПоДопНастройкам(ИзмененныеДни,ДатаДня, ДопНастройка.ЗначениеНастройки, ОбъектЗаполнения);
				КонецЕсли;
				Возврат ДопНастройка.КоличествоРабочихЧасов;
			КонецЕсли;
			
			Если ДопНастройка.ЗначениеНастройки = "В праздники" И (ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник
				ИЛИ (Не ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный И ЗначениеЗаполнено(ДатаПереноса))) Тогда
				Если Не ДопНастройка.КоличествоРабочихЧасов = 0 Тогда
					ЗаполнитьПериодыПоДопНастройкам(ИзмененныеДни,ДатаДня, ДопНастройка.ЗначениеНастройки, ОбъектЗаполнения);
				КонецЕсли;
				Возврат ДопНастройка.КоличествоРабочихЧасов;
			КонецЕсли;
			
			Если ДопНастройка.ЗначениеНастройки = "В предпраздничных днях" И ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный Тогда
				Если Не ДопНастройка.КоличествоРабочихЧасов = 0 Тогда
					ЗаполнитьПериодыПоДопНастройкам(ИзмененныеДни,ДатаДня, ДопНастройка.ЗначениеНастройки, ОбъектЗаполнения);
				КонецЕсли;
				Возврат ДопНастройка.КоличествоРабочихЧасов;
			КонецЕсли;
			
			Если ДопНастройка.ЗначениеНастройки = "В выходные"
				И (ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник
				ИЛИ ДеньНедели(ДатаДня) = 6
				Или ДеньНедели(ДатаДня) = 7) Тогда
				Если Не ДопНастройка.КоличествоРабочихЧасов = 0 Тогда
					ЗаполнитьПериодыПоДопНастройкам(ИзмененныеДни,ДатаДня, ДопНастройка.ЗначениеНастройки, ОбъектЗаполнения);
				КонецЕсли;
				
				Возврат ДопНастройка.КоличествоРабочихЧасов;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат 0;
	
КонецФункции

Процедура ЗаполнитьПериодыПоДопНастройкам(ИзмененныеДни, ДатаДня, ЗначениеНастройки, ОбъектЗаполнения)
	
	ПараметрыОтбора = Новый Структура("ЗначениеНастройки", ЗначениеНастройки);
	
	СтрокиДопНастроек = ОбъектЗаполнения.ПериодыДополнительныхНастроекЗаполнения.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого СтрокаДопНастройки Из СтрокиДопНастроек Цикл
		
		НоваяСтрока = ИзмененныеДни.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДопНастройки);
		
		НоваяСтрока.ДатаДня = ДатаДня;
		
	КонецЦикла;
	
	
КонецПроцедуры

// Функция читает данные производственного календаря из регистра.
//
// Параметры:
//	ПроизводственныйКалендарь			- Ссылка на текущий элемент справочника.
//	НомерГода							- Номер года, за который необходимо прочитать производственный календарь.
//
// Возвращаемое значение
//	ДанныеПроизводственногоКалендаря	- таблица значений, в которой хранятся сведения о виде дня на каждую дату календаря.
//
Функция ДанныеПроизводственногоКалендаря(ПроизводственныйКалендарь, НомерГода) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ПроизводственныйКалендарь",	ПроизводственныйКалендарь);
	Запрос.УстановитьПараметр("ТекущийГод",	НомерГода);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеПроизводственногоКалендаря.Дата,
	|	ДанныеПроизводственногоКалендаря.ВидДня,
	|	ДанныеПроизводственногоКалендаря.ДатаПереноса
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|ГДЕ
	|	ДанныеПроизводственногоКалендаря.Год = &ТекущийГод
	|	И ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПолучитьМесяцПоНомеру(НомерМесяца)
	
	СоответствиеМесяцев = Новый Соответствие();
	СоответствиеМесяцев.Вставить(1, "Январь");
	СоответствиеМесяцев.Вставить(2, "Февраль");
	СоответствиеМесяцев.Вставить(3, "Март");
	СоответствиеМесяцев.Вставить(4, "Апрель");
	СоответствиеМесяцев.Вставить(5, "Май");
	СоответствиеМесяцев.Вставить(6, "Июнь");
	СоответствиеМесяцев.Вставить(7, "Июль");
	СоответствиеМесяцев.Вставить(8, "Август");
	СоответствиеМесяцев.Вставить(9, "Сентябрь");
	СоответствиеМесяцев.Вставить(10, "Октябрь");
	СоответствиеМесяцев.Вставить(11, "Ноябрь");
	СоответствиеМесяцев.Вставить(12, "Декабрь");
	
	Возврат СоответствиеМесяцев.Получить(НомерМесяца); 
	
КонецФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
		Если Не Параметры.Отбор.Свойство("Недействителен") Тогда
			Параметры.Отбор.Вставить("Недействителен", Ложь);
		КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли