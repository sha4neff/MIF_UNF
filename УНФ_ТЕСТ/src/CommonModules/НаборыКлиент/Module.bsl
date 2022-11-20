
#Область ПрограммныйИнтерфейс

Функция ОбрабатыватьОповещения(Форма, ИмяСобытия, Источник) Экспорт
	
	Возврат (ИмяСобытия=ИмяСобытияИзменениеСоставаНабора() И Источник=Форма.УникальныйИдентификатор);	
	
КонецФункции

Процедура УдалитьСтрокиНабора(НоменклатураНабора, ХарактеристикаНабора, НомерВариантаКП = Неопределено, Запасы, ДобавленныеНаборы) Экспорт
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("НоменклатураНабора", НоменклатураНабора);
	СтруктураОтбора.Вставить("ХарактеристикаНабора", ХарактеристикаНабора);
	Если НомерВариантаКП<>Неопределено Тогда
		СтруктураОтбора.Вставить("НомерВариантаКП", НомерВариантаКП);
	КонецЕсли; 
	СтрокиНабора = Запасы.НайтиСтроки(СтруктураОтбора);
	Для каждого Стр Из СтрокиНабора Цикл
		Запасы.Удалить(Стр);
	КонецЦикла;
	ДобавленныеСтроки = ДобавленныеНаборы.НайтиСтроки(СтруктураОтбора);
	Для каждого Стр Из ДобавленныеСтроки Цикл
		ДобавленныеНаборы.Удалить(Стр);
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьЛишниеСтрокиПодчиненнойТЧ(ОсновнаяТЧ, ПодчиненнаяТЧ, ИмяРеквизитаКлючСвязи = "КлючСвязи") Экспорт
	
	МассивДействующихКлючей = Новый Массив;
	
	Для каждого Стр Из ОсновнаяТЧ Цикл
		Если Стр[ИмяРеквизитаКлючСвязи]>0 И МассивДействующихКлючей.Найти(Стр[ИмяРеквизитаКлючСвязи])=Неопределено Тогда
			МассивДействующихКлючей.Добавить(Стр[ИмяРеквизитаКлючСвязи]);
		КонецЕсли; 
	КонецЦикла;
	
	СтрокиКУдалению = Новый Массив;
	Для каждого Стр Из ПодчиненнаяТЧ Цикл
		Если МассивДействующихКлючей.Найти(Стр[ИмяРеквизитаКлючСвязи])=Неопределено Тогда
			СтрокиКУдалению.Добавить(Стр);
		КонецЕсли; 
	КонецЦикла;
	
	Для каждого Стр Из СтрокиКУдалению Цикл
		ПодчиненнаяТЧ.Удалить(Стр);
	КонецЦикла; 
	
КонецПроцедуры
 
#КонецОбласти 

#Область СлужебныйПрограммныйИнтерфейс

Функция ИмяСобытияИзменениеСоставаНабора() Экспорт
	
	Возврат "ИзмененСоставНабора";	
	
КонецФункции

#КонецОбласти 

 