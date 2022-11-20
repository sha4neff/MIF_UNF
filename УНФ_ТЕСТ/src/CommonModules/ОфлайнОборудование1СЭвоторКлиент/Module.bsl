#Область ПрограммныйИнтерфейс
// Функция возвращает возможность работы модуля в асинхронном режиме.
// Стандартные команды модуля:
// - ПодключитьУстройство
// - ОтключитьУстройство
// - ВыполнитьКоманду
// Команды модуля для работы асинхронном режиме (должны быть определены):
// - НачатьПодключениеУстройства
// - НачатьОтключениеУстройства
// - НачатьВыполнениеКоманды.
//
Функция ПоддержкаАсинхронногоРежима () Экспорт
	
	Возврат Истина;
	
КонецФункции

// Функция осуществляет подключение устройства.
// Параметры:
//  ОбъектДрайвера - СправочникСсылка.ДрайверыОборудования - Объект драйвера торгового оборудования.
//  Параметры - Структура - Параметры устройства.
//  ПараметрыПодключения - Структура - Параметры подключения устройства.
//  ВыходныеПараметры - Структура - ВыходныеПараметрыФункции.
//
// Возвращаемое значение:
//  Булево - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт
	
	Результат      		= Истина;
	ВыходныеПараметры 	= Новый Массив();
	ОбъектДрайвера 		= Неопределено;
	ВходныеПараметры 	= Неопределено;
	
	ТокенПриложения = Неопределено;
	Магазин         = Неопределено;
	Терминал        = Неопределено;
	
	Параметры.Свойство("Токен", ТокенПриложения);
	Параметры.Свойство("Магазин", Магазин);
	Параметры.Свойство("Терминал", Терминал);
	
	Если ТокенПриложения = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
		|Для корректной работы устройства необходимо задать параметры его работы.'"));
		Результат = Ложь;
	Иначе
		ОбъектДрайвера = Новый Структура("Параметры", Параметры);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция начинает подключения устройства.
// Параметры:
//  ОповещениеПоЗавершении - ОписаниеОповещения - Описание оповещения для выполнения.
//  ОбъектДрайвера - СправочникСсылка.ДрайверыОборудования - Объект драйвера торгового оборудования.
//  Параметры - Структура - Параметры устройства.
//  ПараметрыПодключения - Структура - Параметры подключения устройства.
//  ДополнительныеПараметры - Структура - Дополнительные параметры команды.
//
// Возвращаемое значение:
//  Булево - Результат работы функции.
//
Процедура НачатьПодключениеУстройства(ОповещениеПриЗавершении, ОбъектДрайвера, Параметры, ПараметрыПодключения, ДополнительныеПараметры) Экспорт
	
	ВыходныеПараметры = Неопределено;
	Результат = ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

// Функция осуществляет отключение устройства.
// Параметры:
//  ОбъектДрайвера - СправочникСсылка.ДрайверыОборудования - Объект драйвера торгового оборудования.
//  Параметры - Структура - Параметры устройства.
//  ПараметрыПодключения - Структура - Параметры подключения устройства.
//  ВыходныеПараметры - Структура - ВыходныеПараметрыФункции.
//
// Возвращаемое значение:
//  Булево - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;
	Возврат Результат;

КонецФункции

// Функция начинает отключение устройства.
// Параметры:
//  ОповещениеПоЗавершении - ОписаниеОповещения - Описание оповещения для выполнения.
//  ОбъектДрайвера - СправочникСсылка.ДрайверыОборудования - Объект драйвера торгового оборудования.
//  Параметры - Структура - Параметры устройства.
//  ПараметрыПодключения - Структура - Параметры подключения устройства.
//  ВыходныеПараметры - Структура - ВыходныеПараметрыФункции.
//
// Возвращаемое значение:
//  Булево - Результат работы функции.
//
Процедура НачатьОтключениеУстройства(ОповещениеПриЗавершении, ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт
	
	Результат = ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу
// Параметры:
//  Команда - Строка - НаименованиеКоманды.
//  ВходныеПараметры - Структура - ВыходныеПараметрыФункции.
//  ВыходныеПараметры - Структура - ВыходныеПараметрыФункции.
//  ОбъектДрайвера - СправочникСсылка.ДрайверыОборудования - Объект драйвера торгового оборудования.
//  Параметры - Структура - Параметры устройства.
//  ПараметрыПодключения - Структура - Параметры подключения устройства.
//
// Возвращаемое значение:
//  Булево - Результат работы функции.
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
							 ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;
	
	ВыходныеПараметры = Новый Массив();

	Если Команда = "ЗагрузитьМагазины" Тогда
		Результат = ЗагрузитьМагазины(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ЗагрузитьТерминалы" Тогда
		Результат = ЗагрузитьТерминалы(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ЗагрузитьСотрудников" Тогда
		Результат = ЗагрузитьСотрудников(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ЗагрузитьТовары" Тогда
		Результат = ЗагрузитьТовары(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ЗагрузитьДанные" Тогда
		Результат = ЗагрузитьДокументы(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ВыгрузитьДанные" Тогда 
		Результат = ПередатьТовары(Параметры, ВходныеПараметры.ДанныеДляВыгрузки.ПрайсЛист, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ОчиститьБазу" Тогда
		Результат = УдалитьТовары(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ТестУстройства" Тогда
		Результат = ТестУстройства(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Процедура начинает выполнение команды, обрабатывает и перенаправляет на исполнение команду к драйверу.
//  ОповещениеПоЗавершении - * - Описание оповещения для выполнения.
//  Команда - Строка - НаименованиеКоманды.
//  ВходныеПараметры - Структура - ВыходныеПараметрыФункции.
//  ОбъектДрайвера - СправочникСсылка.ДрайверыОборудования - Объект драйвера торгового оборудования.
//  Параметры - Структура - Параметры устройства.
//  ПараметрыПодключения - Структура - Параметры подключения устройства.
//
Процедура НачатьВыполнениеКоманды(ОповещениеПриЗавершении, Команда, ВходныеПараметры = Неопределено, ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт
	
	ВыходныеПараметры = Новый Массив();
	
	Если Команда = "ЗагрузитьМагазины" Тогда
		НачатьЗагрузкуМагазинов(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ЗагрузитьТерминалы" Тогда
		НачатьЗагрузкуТерминалов(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ЗагрузитьСотрудников" Тогда
		НачатьЗагрузкуСотрудников(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ЗагрузитьТовары" Тогда
		НачатьЗагрузкуТоваров(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ЗагрузитьДанные" Тогда
		НачатьЗагрузкуДокументов(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ВыгрузитьДанные" Тогда
		НачатьПередачуТоваров(ОповещениеПриЗавершении, Параметры, ВходныеПараметры.ДанныеДляВыгрузки.ПрайсЛист, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ОчиститьБазу" Тогда
		НачатьУдалениеТоваров(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		НачатьТестУстройства(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	ИначеЕсли Команда = "УстановитьФлагДанныеЗагружены" Тогда
		НачатьУстановкуФлагаДанныеЗагружены(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда);
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		Если ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#Область КомандыДрайвера
#Область СинхронныеКоманды
// Функция осуществляет загрузку магазинов из облака Эвотор
//
Функция ЗагрузитьМагазины(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	Результат = ОфлайнОборудование1СЭвоторВызовСервера.ОтправитьЗапрос(ПараметрыЗапроса, ВыходныеПараметры);
	Если Результат Тогда
		РезультатЗапроса = ВыходныеПараметры[0];
		СтруктураОтвета = ОфлайнОборудование1СЭвоторВызовСервера.ЗаполнитьСтруктуруОтвета(РезультатЗапроса, ВыходныеПараметры);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет загрузку терминалов из облака Эвотор
//
Функция ЗагрузитьТерминалы(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	Результат = ОфлайнОборудование1СЭвоторВызовСервера.ОтправитьЗапрос(ПараметрыЗапроса, ВыходныеПараметры);
	Если Результат Тогда
		РезультатЗапроса = ВыходныеПараметры[0];
		СтруктураОтвета = ОфлайнОборудование1СЭвоторВызовСервера.ЗаполнитьСтруктуруОтвета(РезультатЗапроса, ВыходныеПараметры);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет загрузку сотрудников из облака Эвотор
//
Функция ЗагрузитьСотрудников(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	Результат = ОфлайнОборудование1СЭвоторВызовСервера.ОтправитьЗапрос(ПараметрыЗапроса, ВыходныеПараметры);
	Если Результат Тогда
		РезультатЗапроса = ВыходныеПараметры[0];
		СтруктураОтвета = ОфлайнОборудование1СЭвоторВызовСервера.ЗаполнитьСтруктуруОтвета(РезультатЗапроса, ВыходныеПараметры);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет загрузку товаров из облака Эвотор
//
Функция ЗагрузитьТовары(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	Результат = ОфлайнОборудование1СЭвоторВызовСервера.ОтправитьЗапрос(ПараметрыЗапроса, ВыходныеПараметры);
	Если Результат Тогда
		РезультатЗапроса = ВыходныеПараметры[0];
		СтруктураОтвета = ОфлайнОборудование1СЭвоторВызовСервера.ЗаполнитьСтруктуруОтвета(РезультатЗапроса, ВыходныеПараметры);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет загрузку документов из облака Эвотор
//
Функция ЗагрузитьДокументы(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	ТелоЗапроса = Неопределено;
	ДанныеОтвета = Неопределено;
	Результат = ОфлайнОборудование1СЭвоторВызовСервера.ОтправитьЗапрос(ПараметрыЗапроса, ВыходныеПараметры);
	Если Результат Тогда
		РезультатЗапроса  = ВыходныеПараметры[0];
		Если ЗначениеЗаполнено(РезультатЗапроса) Тогда
			РезультатОбработки = ОфлайнОборудование1СЭвоторВызовСервера.ЗаполнитьСтруктуруОтвета(РезультатЗапроса, ДанныеОтвета);
		Иначе
			РезультатОбработки = Ложь;
		КонецЕсли;
		
		Если РезультатОбработки Тогда
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("НаименованиеКоманды",     Команда);
			ВыходныеПараметры = ОфлайнОборудование1СЭвоторВызовСервера.ОбработатьДанныеЗапроса(ДанныеОтвета, ДополнительныеПараметры);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет выгрузку товаров в облако Эвотор
//
Функция ПередатьТовары(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	ТекстЗапроса = ОфлайнОборудование1СЭвоторВызовСервера.ПолучитьТекстJSONЗапроса(ВходныеПараметры, "ВыгрузитьДанные");
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	Результат = ОфлайнОборудование1СЭвоторВызовСервера.ОтправитьЗапрос(ПараметрыЗапроса, ВыходныеПараметры);
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет удаление товаров в облаке Эвотор
//
Функция УдалитьТовары(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	ТекстЗапроса = ОфлайнОборудование1СЭвоторВызовСервера.ПолучитьТекстJSONЗапроса(ВходныеПараметры, "УдалитьТовары");
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	Результат = ОфлайнОборудование1СЭвоторВызовСервера.ОтправитьЗапрос(ПараметрыЗапроса, ВыходныеПараметры);
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет тест устройства
Функция ТестУстройства(Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	Результат = ОфлайнОборудование1СЭвоторВызовСервера.ОтправитьЗапрос(ПараметрыЗапроса, ВыходныеПараметры);
	
	Возврат Результат;
	
КонецФункции
#КонецОбласти

#Область АсинхронныеКоманды

// Функция осуществляет загрузку магазинов из облака Эвотор
//
Процедура НачатьЗагрузкуМагазинов(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	РезультатЗапроса = Новый Структура;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры",       ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("ПараметрыЗапроса",        ПараметрыЗапроса);
	ДополнительныеПараметры.Вставить("НаименованиеКоманды",     Команда);
	
	ОповещениеОтправкиЗапроса = Новый ОписаниеОповещения("НачатьПринятиеДанных", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеОтправкиЗапроса, РезультатЗапроса);
	
КонецПроцедуры

// Функция осуществляет загрузку терминалов из облака Эвотор
//
Процедура НачатьЗагрузкуТерминалов(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	РезультатЗапроса = Новый Структура;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры",       ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("ПараметрыЗапроса",        ПараметрыЗапроса);
	ДополнительныеПараметры.Вставить("НаименованиеКоманды",     Команда);
	
	ОповещениеОтправкиЗапроса = Новый ОписаниеОповещения("НачатьПринятиеДанных", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеОтправкиЗапроса, РезультатЗапроса);
	
КонецПроцедуры

// Функция осуществляет загрузку сотрудников из облака Эвотор
//
Процедура НачатьЗагрузкуСотрудников(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	РезультатЗапроса = Новый Структура;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры",       ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("ПараметрыЗапроса",        ПараметрыЗапроса);
	ДополнительныеПараметры.Вставить("НаименованиеКоманды",     Команда);
	
	ОповещениеОтправкиЗапроса = Новый ОписаниеОповещения("НачатьПринятиеДанных", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеОтправкиЗапроса, РезультатЗапроса);
	
КонецПроцедуры

// Функция осуществляет загрузку товаров из облака Эвотор
//
Процедура НачатьЗагрузкуТоваров(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	РезультатЗапроса = Новый Структура;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры",       ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("ПараметрыЗапроса",        ПараметрыЗапроса);
	ДополнительныеПараметры.Вставить("НаименованиеКоманды",     Команда);
	
	ОповещениеОтправкиЗапроса = Новый ОписаниеОповещения("НачатьПринятиеДанных", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеОтправкиЗапроса, РезультатЗапроса);
	
КонецПроцедуры

// Функция осуществляет загрузку документов из облака Эвотор
//
// Параметры:
// 	ОповещениеПриЗавершении - ОписаниеОповещения - описание оповещения при завершении операции.
// 	Параметры - Структура - структура с полями:
// 	*ДатаНачала - Дата - начало выгрузки.
// 	*ДатаОкончания - Дата - окончание выгрузки.
// 	ВходныеПараметры - Структура - структура с полями:
// * ДатаОкончанияВыгрузки - Дата - дата окончания выгрузки.
// * ДатаНачалаВыгрузки - Дата - дата начала выгрузки.
// 	ВыходныеПараметры - Массив - Описание
// 	Команда - Строка - наименование команды.
Процедура НачатьЗагрузкуДокументов(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	РезультатЗапроса = Новый Структура;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВыходныеПараметры",       ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("НаименованиеКоманды",     Команда);
	
	Если Параметры.ЭтоПерваяЗагрузка Тогда
		ДополнительныеПараметры.Вставить("ДатаНачалаВыгрузки",      Параметры.ДатаНачала);
		ОфлайнОборудование1СЭвоторВызовСервера.ПолучитьДатуПоследнейЗагрузки(Параметры, ДополнительныеПараметры);
	Иначе
		ДополнительныеПараметры.Вставить("ДатаНачалаВыгрузки",       ВходныеПараметры.ДатаНачалаВыгрузки);
		ДополнительныеПараметры.Вставить("ДатаОкончанияВыгрузки",    ВходныеПараметры.ДатаОкончанияВыгрузки);
		ОфлайнОборудование1СЭвоторВызовСервера.ИзменитьДатуПоследнейЗагрузки(Параметры, ВходныеПараметры.ДатаОкончанияВыгрузки);
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	ДополнительныеПараметры.Вставить("ПараметрыУстройства",     Параметры);
	ДополнительныеПараметры.Вставить("ПараметрыЗапроса",        ПараметрыЗапроса);
	
	ОповещениеОтправкиЗапроса = Новый ОписаниеОповещения("НачатьПринятиеДанных", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеОтправкиЗапроса, РезультатЗапроса);
	
КонецПроцедуры

// Функция осуществляет выгрузку товаров в облако Эвотор
//
Процедура НачатьПередачуТоваров(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	РезультатЗапроса = Новый Структура;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры",       ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("ПараметрыЗапроса",        ПараметрыЗапроса);
	ДополнительныеПараметры.Вставить("ВходныеПараметры",        ВходныеПараметры);
	ДополнительныеПараметры.Вставить("НаименованиеКоманды",     Команда);
	
	ОповещениеОтправкиЗапроса = Новый ОписаниеОповещения("НачатьОтправкуДанных", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеОтправкиЗапроса, РезультатЗапроса);
	
КонецПроцедуры

// Функция осуществляет удаление товаров в облаке Эвотор
//
Процедура НачатьУдалениеТоваров(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	РезультатЗапроса = Новый Структура;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры",       ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("ПараметрыЗапроса",        ПараметрыЗапроса);
	ДополнительныеПараметры.Вставить("ВходныеПараметры",        ВходныеПараметры);
	ДополнительныеПараметры.Вставить("НаименованиеКоманды",     Команда);
	
	ОповещениеОтправкиЗапроса = Новый ОписаниеОповещения("НачатьОтправкуДанных", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеОтправкиЗапроса, РезультатЗапроса);
	
КонецПроцедуры

// Функция осуществляет загрузку магазинов из облака Эвотор
//
Процедура НачатьТестУстройства(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	РезультатЗапроса = Новый Структура;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса = ЗаполнитьПараметрыЗапроса(Команда, Параметры);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры",       ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("ПараметрыЗапроса",        ПараметрыЗапроса);
	ДополнительныеПараметры.Вставить("НаименованиеКоманды",     Команда);
	
	ОповещениеОтправкиЗапроса = Новый ОписаниеОповещения("НачатьПринятиеДанных", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеОтправкиЗапроса, РезультатЗапроса);
	
КонецПроцедуры

Процедура НачатьУстановкуФлагаДанныеЗагружены(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры, Команда)
	
	Результат = ОфлайнОборудование1СЭвоторВызовСервера.ЗаполнитьДатуПоследнейЗагрузки(Параметры, ВыходныеПараметры);
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Процедура НачатьОтправкуДанных(Результат, ДополнительныеПараметры) Экспорт
	
	ВыходныеПараметры = Новый Массив;
	ТекстЗапроса = ОфлайнОборудование1СЭвоторВызовСервера.ПолучитьТекстJSONЗапроса(ДополнительныеПараметры.ВходныеПараметры, ДополнительныеПараметры.НаименованиеКоманды);
	ДополнительныеПараметры.ПараметрыЗапроса.Вставить("ТекстЗапроса", ТекстЗапроса);
	
	Результат = ОфлайнОборудование1СЭвоторВызовСервера.ОтправитьЗапрос(ДополнительныеПараметры.ПараметрыЗапроса, ВыходныеПараметры);
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

// Осуществляет принятие данных.
// 
// Параметры:
// 	Результат - Структура - структура результата выполнения операции.
// 	ДополнительныеПараметры - Структура - структура с полями:
// 	*ПараметрыУстройства - Структура - структура параметров устройства с полями:
// 	**ДатаОкончания - Дата - дата окончания загрузки.
// 	**ДатаНачала - Дата - дата начала загрузки.
// 	**Идентификатор - Строка - уникальный идентификатор терминала.
// 	**Магазин - УникальныйИдентификатор - уникальный идентификатор магазина.
// 	**Терминал - УникальныйИдентификатор - уникальный идентификатор терминала.
Процедура НачатьПринятиеДанных(Результат, ДополнительныеПараметры) Экспорт
	
	СтруктураОтвета   = Новый Структура;
	ТелоЗапроса       = Новый Массив;
	ВходныеПараметры  = Неопределено;
	МассивДанных      = Новый Массив;
	
	Результат = ОфлайнОборудование1СЭвоторВызовСервера.ОтправитьЗапрос(ДополнительныеПараметры.ПараметрыЗапроса, ТелоЗапроса);
	Если Результат Тогда
		СтруктураОтвета = ОфлайнОборудование1СЭвоторВызовСервера.ЗаполнитьСтруктуруОтвета(ТелоЗапроса[0], МассивДанных);
		ДополнитьМассив(ДополнительныеПараметры.ВыходныеПараметры, МассивДанных);
		ДополнительныеПараметры.Вставить("Результат", Результат);
	Иначе
		ДополнительныеПараметры.ВыходныеПараметры.Очистить();
		ДополнительныеПараметры.ВыходныеПараметры = ТелоЗапроса;
		ДополнительныеПараметры.Вставить("Результат", Результат);
		Если ДополнительныеПараметры.НаименованиеКоманды = "ЗагрузитьДанные" Тогда
			ДополнительныеПараметры.ПараметрыУстройства.ДатаОкончания = ДополнительныеПараметры.ДатаОкончанияВыгрузки;
		КонецЕсли;
	КонецЕсли;
	
	Если ДополнительныеПараметры.НаименованиеКоманды = "ЗагрузитьДанные" Тогда
		Если ДополнительныеПараметры.ПараметрыУстройства.ДатаОкончания < ДополнительныеПараметры.ДатаОкончанияВыгрузки Тогда
			ДополнительныеПараметры.ПараметрыУстройства.ЭтоПерваяЗагрузка = Ложь;
			ВходныеПараметры = Новый Структура;
			ВходныеПараметры.Вставить("ДатаНачалаВыгрузки", ДополнительныеПараметры.ДатаНачалаВыгрузки);
			ВходныеПараметры.Вставить("ДатаОкончанияВыгрузки", ДополнительныеПараметры.ДатаОкончанияВыгрузки);
			НачатьЗагрузкуДокументов(ДополнительныеПараметры.ОповещениеПриЗавершении, ДополнительныеПараметры.ПараметрыУстройства,
			ВходныеПараметры, ДополнительныеПараметры.ВыходныеПараметры, ДополнительныеПараметры.НаименованиеКоманды);
		Иначе
			ДополнительныеПараметры.Вставить("Результат", Результат);
			ОповещениеОбработкиДанных = Новый ОписаниеОповещения("НачатьОбработкуДанных", ЭтотОбъект, ДополнительныеПараметры);
			ВыполнитьОбработкуОповещения(ОповещениеОбработкиДанных, ДополнительныеПараметры.ВыходныеПараметры);
		КонецЕсли;
	Иначе
		ОповещениеОбработкиДанных = Новый ОписаниеОповещения("НачатьОбработкуДанных", ЭтотОбъект, ДополнительныеПараметры);
		ВыполнитьОбработкуОповещения(ОповещениеОбработкиДанных, ДополнительныеПараметры.ВыходныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

// Осуществляет обработку данных.
// 
// Параметры:
// 	Результат - Структура - структура результата выполнения операции.
// 	ДополнительныеПараметры - Структура - структура с полями:
// 	*ПараметрыУстройства - Структура - структура параметров устройства с полями:
// 	**ДатаОкончания - Дата - дата окончания загрузки.
// 	**ДатаНачала - Дата - дата начала загрузки.
// 	**Идентификатор - Строка - уникальный идентификатор терминала.
// 	**Магазин - УникальныйИдентификатор - уникальный идентификатор магазина.
// 	**Терминал - УникальныйИдентификатор - уникальный идентификатор терминала.
Процедура НачатьОбработкуДанных(Результат, ДополнительныеПараметры) Экспорт
	
	СтруктураДанных = Новый Структура;
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("НаименованиеКоманды", ДополнительныеПараметры.НаименованиеКоманды);
	
	Если Не ДополнительныеПараметры.Результат Тогда
		ТекстСообщения = НСтр("ru ='%Наименование%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Наименование%", Результат[1]);
		Результат.Очистить();
		СоздатьСообщениеОбОшибке(Результат, ТекстСообщения);
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, Результат);
	Иначе
		Если ДополнительныеПараметры.НаименованиеКоманды = "ЗагрузитьДанные" Тогда
			ПараметрыКоманды.Вставить("ДатаНачалаВыгрузки", ДополнительныеПараметры.ДатаНачалаВыгрузки);
			ПараметрыКоманды.Вставить("ДатаСмены");
			СтруктураДанных = ОфлайнОборудование1СЭвоторВызовСервера.ОбработатьДанныеЗапроса(Результат, ПараметрыКоманды);
			Если Не ЗначениеЗаполнено(СтруктураДанных[0].ОтчетыОПродажах) И Не ЗначениеЗаполнено(СтруктураДанных[0].ВскрытияАлкогольнойТары) Тогда
				ТекстСообщения = НСтр("ru = 'Нет данных для заполнения'");
				Результат.Очистить();
				СоздатьСообщениеОбОшибке(Результат, ТекстСообщения);
				РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, Результат);
			Иначе
				РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Истина, СтруктураДанных);
				Если ЗначениеЗаполнено(ПараметрыКоманды.ДатаСмены) Тогда
					ДополнительныеПараметры.ПараметрыУстройства.ДатаОкончания = ПараметрыКоманды.ДатаСмены;
				КонецЕсли;
				ОфлайнОборудование1СЭвоторВызовСервера.ЗаполнитьДатуПоследнейПопыткиЗагрузки(ДополнительныеПараметры.ПараметрыУстройства, ДополнительныеПараметры.ДатаОкончанияВыгрузки);
			КонецЕсли;
		Иначе
			СтруктураДанных = ОфлайнОборудование1СЭвоторВызовСервера.ОбработатьДанныеЗапроса(Результат, ПараметрыКоманды);
			РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Истина, СтруктураДанных);
		КонецЕсли;
	КонецЕсли;
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

// Процедура добавляет в массив выходных параметров сообщение об ошибке.
//
//Параметры:
// ВыходныеПараметры - Массив - массив, в который будет помещено сообщение об ошибке.
// ТекстСообщения - Строка - текст сообщения, содержащий информация об ошибке.
Процедура СоздатьСообщениеОбОшибке(ВыходныеПараметры, ТекстСообщения)
	
	ВыходныеПараметры.Добавить(999);
	ВыходныеПараметры.Добавить(ТекстСообщения);
	
КонецПроцедуры

Функция ЗаполнитьПараметрыЗапроса(КомандаЗапроса, Параметры)
	
	ЗаголовкиЗапроса = Новый Соответствие();
	ЗаголовкиЗапроса.Вставить("Content-Type", "application/json");
	ЗаголовкиЗапроса.Вставить("X-Authorization", Параметры.Токен);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("СерверЗапроса",    "api.evotor.ru");
	ПараметрыЗапроса.Вставить("ЗаголовкиЗапроса", ЗаголовкиЗапроса);
	
	Если КомандаЗапроса = "ЗагрузитьМагазины" Тогда
		АдресЗапроса = "api/v1/inventories/stores/search";
		МетодЗапроса = "GET";
	ИначеЕсли КомандаЗапроса = "ЗагрузитьТерминалы" Тогда
		АдресЗапроса = "api/v1/inventories/devices/search";
		МетодЗапроса = "GET";
	ИначеЕсли КомандаЗапроса = "ЗагрузитьСотрудников" Тогда
		АдресЗапроса = "api/v1/inventories/employees/search";
		МетодЗапроса = "GET";
	ИначеЕсли КомандаЗапроса = "ЗагрузитьТовары" Тогда
		АдресЗапроса = "api/v1/inventories/stores/"+ Параметры.МагазинЗначение + "/products";
		МетодЗапроса = "GET";
	ИначеЕсли КомандаЗапроса = "ЗагрузитьДанные" Тогда
		АдресЗапроса = "api/v1/inventories/stores/" + Параметры.МагазинЗначение + "/documents";
		
		Если ЗначениеЗаполнено(Параметры.ТерминалЗначение) Тогда
			АдресЗапроса = АдресЗапроса + "?deviceUuid=" + Параметры.ТерминалЗначение;
		Иначе
			АдресЗапроса = АдресЗапроса + "?deviceUuid=";
		КонецЕсли;
		
		НачалоВыгрузки = ОфлайнОборудование1СЭвоторВызовСервера.ПреобразоватьДату(Параметры.ДатаНачала);
		Если ЗначениеЗаполнено(Параметры.ДатаНачала) Тогда
			АдресЗапроса = АдресЗапроса + "&gtCloseDate=" + НачалоВыгрузки;
		Иначе
			АдресЗапроса = АдресЗапроса + "&gtCloseDate=";
		КонецЕсли;
		
		ОкончаниеВыгрузки = ОфлайнОборудование1СЭвоторВызовСервера.ПреобразоватьДату(Параметры.ДатаОкончания);
		Если ЗначениеЗаполнено(Параметры.ДатаОкончания) Тогда
			АдресЗапроса = АдресЗапроса + "&ltCloseDate=" + ОкончаниеВыгрузки;
		Иначе
			АдресЗапроса = АдресЗапроса + "&ltCloseDate=";
		КонецЕсли;
		
		АдресЗапроса = АдресЗапроса + "&types=SELL,PAYBACK,CASH_INCOME,CASH_OUTCOME,OPEN_SESSION,FPRINT,CLOSE_SESSION,OPEN_TARE";
		МетодЗапроса = "GET";
		
	ИначеЕсли КомандаЗапроса = "ВыгрузитьДанные" Тогда
		АдресЗапроса = "api/v1/inventories/stores/" + Параметры.МагазинЗначение + "/products";
		МетодЗапроса = "POST";
		ЗаголовкиЗапроса.Вставить("Content-Encoding", "gzip");
	ИначеЕсли КомандаЗапроса = "ОчиститьБазу" Тогда
		АдресЗапроса = "api/v1/inventories/stores/" + Параметры.МагазинЗначение + "/products/delete";
		МетодЗапроса = "POST";
		ЗаголовкиЗапроса.Вставить("Content-Encoding", "gzip");
	ИначеЕсли КомандаЗапроса = "ТестУстройства" ИЛИ КомандаЗапроса = "CheckHealth" Тогда
		АдресЗапроса = "api/v1/inventories/stores/search";
		МетодЗапроса = "GET";
	КонецЕсли;
	
	ПараметрыЗапроса.Вставить("АдресЗапроса",     АдресЗапроса);
	ПараметрыЗапроса.Вставить("МетодЗапроса",     МетодЗапроса);
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Процедура ДополнитьМассив(МассивПриемник, МассивИсточник) Экспорт
	
	УникальныеЗначения = Новый Соответствие;
		
	Для Каждого Значение Из МассивПриемник Цикл
		УникальныеЗначения.Вставить(Значение, Истина);
	КонецЦикла;
	
	Для Каждого Значение Из МассивИсточник Цикл
		Если УникальныеЗначения[Значение] = Неопределено Тогда
			МассивПриемник.Добавить(Значение);
			УникальныеЗначения.Вставить(Значение, Истина);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
#КонецОбласти