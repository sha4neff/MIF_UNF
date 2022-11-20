#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура записывает токен запроса, полученный HTTP-сервисом
// ОбработкаОбратногоВызоваOAuth2,в информационную базу
//
// Параметры:
//  Идентификатор	 - УникальныйИдентификатор - значение, переданное в параметре state
//  ТокенЗапроса	 - Строка - токен запроса, переданный в параметре code
//
Процедура ЗаписатьТокенЗапроса(Знач Идентификатор, Знач ТокенЗапроса) Экспорт
	
	ОбщегоНазначенияКлиентСервер.Проверить(
	СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(Идентификатор),
	НСтр("ru = 'Значение, переданное в параметре state.id, не является уникальным идентификатором.'"));
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК КоличествоЗаписей
	|ИЗ
	|	РегистрСведений.ДанныеАвторизацииGoogle КАК ДанныеАвторизацииGoogle");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.КоличествоЗаписей > 1000 Тогда
		ВызватьИсключение НСтр("ru = 'Превышено количество попыток авторизации.'");
	КонецЕсли;
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	МенеджерЗаписи.ТокенЗапроса = ТокенЗапроса;
	МенеджерЗаписи.Дата = ТекущаяУниверсальнаяДата();
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Функция возвращает токен запроса по идентификатору авторизации
//
// Параметры:
//  Идентификатор - УникальныйИдентификатор - параметр, по которому
//                  выполняется сопоставление сеанса авторизации
// 
// Возвращаемое значение:
//  Строка - токен запроса, который можно будет обменять на токен доступа.
//  См. ОбменСGoogle.ОбменятьТокенЗапросаНаСеансовыеДанные()
//
Функция ТокенЗапроса(Знач Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДанныеАвторизацииGoogle.ТокенЗапроса
	|ИЗ
	|	РегистрСведений.ДанныеАвторизацииGoogle КАК ДанныеАвторизацииGoogle
	|ГДЕ
	|	ДанныеАвторизацииGoogle.Идентификатор = &Идентификатор");
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	РезультатЗапроса = РаботаВМоделиСервиса.ВыполнитьЗапросВнеТранзакции(Запрос);
	Если РезультатЗапроса.Пустой() Тогда
		Возврат "";
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ТокенЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли