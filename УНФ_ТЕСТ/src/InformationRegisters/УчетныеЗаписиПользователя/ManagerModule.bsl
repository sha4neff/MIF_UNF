#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает признак того, что текущему пользователю доступна хоть одна учетная запись электронной почты.
//
// Возвращаемое значение:
//  Булево - Истина - Доступна хотя бы одна учетная запись.
//
Функция ПочтовыеСлужбыДоступны() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	НЕ УчетныеЗаписиЭлектроннойПочты.Недействителен
	|	И НЕ УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

// Возвращает признак того, что текущий пользователь включил получение электронной почты.
//
// Возвращаемое значение:
//  Булево - Истина - Подключена для загрузки хотя бы одна учетная запись.
//
Функция ПочтовыеСлужбыПодключены() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.УчетныеЗаписиПользователя КАК УчетныеЗаписиПользователя
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|		ПО УчетныеЗаписиПользователя.УчетнаяЗапись = УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ГДЕ
	|	УчетныеЗаписиПользователя.Пользователь = &Пользователь
	|	И НЕ УчетныеЗаписиЭлектроннойПочты.Ссылка ЕСТЬ NULL
	|	И НЕ УчетныеЗаписиЭлектроннойПочты.Недействителен
	|	И НЕ УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления");
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

// Возвращает таблицу с настройками учетных записей электронной почты для указанного пользователя.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - колонки:
//    * УчетнаяЗапись - СправочникСсылка.УчетнызеЗаписиЭлектроннойПочты,
//    * ЗагружатьПочту - Булево.
//
Функция НастройкаПользователя(Пользователь) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТ_УчетныеЗаписиЭП
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	НЕ УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления
	|	И НЕ УчетныеЗаписиЭлектроннойПочты.Недействителен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетныеЗаписиПользователя.УчетнаяЗапись КАК УчетнаяЗапись
	|ПОМЕСТИТЬ ВТ_УчетныеЗаписиПользователя
	|ИЗ
	|	РегистрСведений.УчетныеЗаписиПользователя КАК УчетныеЗаписиПользователя
	|ГДЕ
	|	УчетныеЗаписиПользователя.Пользователь = &Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ_УчетныеЗаписиЭП.Ссылка КАК УчетнаяЗапись,
	|	ВЫБОР
	|		КОГДА ВТ_УчетныеЗаписиПользователя.УчетнаяЗапись ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЗагружатьПочту
	|ИЗ
	|	ВТ_УчетныеЗаписиЭП КАК ВТ_УчетныеЗаписиЭП
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УчетныеЗаписиПользователя КАК ВТ_УчетныеЗаписиПользователя
	|		ПО ВТ_УчетныеЗаписиЭП.Ссылка = ВТ_УчетныеЗаписиПользователя.УчетнаяЗапись");
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

// Устанавливает признак того, что для указанной учетной записи следует загружать электронную почту.
//
// Параметры:
//  Пользователь	 - СправочникСсылка.Пользователи,
//  УчетнаяЗапись	 - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты,
//  ЗагружатьПочту	 - Булево.
//
Процедура УстановитьПризнакЗагружатьПочту(Пользователь, УчетнаяЗапись, ЗагружатьПочту) Экспорт
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Пользователь = Пользователь;
	МенеджерЗаписи.УчетнаяЗапись = УчетнаяЗапись;
	
	Если ЗагружатьПочту Тогда
		МенеджерЗаписи.Записать();
	Иначе
		МенеджерЗаписи.Удалить();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает признак необходимости поместить отправляемое сообщение на сервер IMAP.
// Отправляемые сообщения помещаются на сервер IMAP только когда для них установлены
// признаки "Использовать для отправки" в диалоге учётной записи
// и "Загружать почту" в диалоге "Мои учетные записи".
// Такое поведение используется для совместимости с настройками из предыдущих версий.
//
// Параметры:
//  УчетнаяЗапись	 - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты.
// 
// Возвращаемое значение:
//  Булево.
//
Функция ПомещатьОтправляемоеСообщениеНаСерверIMAP(УчетнаяЗапись) Экспорт
	
	Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, "ИспользоватьДляОтправки") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УчетныеЗаписиПользователя.УчетнаяЗапись
	|ИЗ
	|	РегистрСведений.УчетныеЗаписиПользователя КАК УчетныеЗаписиПользователя
	|ГДЕ
	|	УчетныеЗаписиПользователя.УчетнаяЗапись = &УчетнаяЗапись");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоАвторизованныйПользователь(Пользователь)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
