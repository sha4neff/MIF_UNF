#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьСертификат(Знач ИдентификаторЭДО, Знач Сертификаты, ПрочитатьСписокСертификатов = Ложь) Экспорт
	
	Если ТипЗнч(Сертификаты) <> Тип("Массив") Тогда
		Сертификаты = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сертификаты);
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.СертификатыУчетныхЗаписейЭДО");
		ЭлементБлокировкиДанных.УстановитьЗначение("ИдентификаторЭДО", ИдентификаторЭДО);
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.СертификатыУчетныхЗаписейЭДО.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИдентификаторЭДО.Установить(ИдентификаторЭДО);
		
		Если ПрочитатьСписокСертификатов Тогда 
			НаборЗаписей.Прочитать();
		КонецЕсли;
		
		СертификатыДействителенДо = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Сертификаты, "ДействителенДо");
		ТаблицаЗаписей = НаборЗаписей.Выгрузить();
		
		Для Каждого Сертификат Из Сертификаты Цикл 
			
			НоваяЗапись = ТаблицаЗаписей.Добавить();
			НоваяЗапись.ИдентификаторЭДО = ИдентификаторЭДО;
			НоваяЗапись.Сертификат = Сертификат;
			НоваяЗапись.ДействителенДо = СертификатыДействителенДо.Получить(Сертификат);
			
		КонецЦикла;
		
		ТаблицаЗаписей.Свернуть("ИдентификаторЭДО, Сертификат, ДействителенДо");
		
		НаборЗаписей.Загрузить(ТаблицаЗаписей);
		НаборЗаписей.Записать(Истина);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Информация = ИнформацияОбОшибке();
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Обновление сертификатов учетной записи'"),
			ПодробноеПредставлениеОшибки(Информация),
			СтрШаблон(НСтр("ru = 'Не удалось обновить сертификаты по ученой записи: %1'"), ИдентификаторЭДО));
			
	КонецПопытки;
	
КонецПроцедуры

Функция СертификатыУчетнойЗаписи(ИдентификаторЭДО) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СертификатыУчетныхЗаписейЭДО.Сертификат КАК Сертификат
		|ИЗ
		|	РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК СертификатыУчетныхЗаписейЭДО
		|ГДЕ
		|	СертификатыУчетныхЗаписейЭДО.ИдентификаторЭДО = &ИдентификаторЭДО";
	
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ИдентификаторЭДО);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Сертификат");
	
КонецФункции

#КонецОбласти

#КонецЕсли