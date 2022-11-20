#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустой() Тогда
		
		АвтоНаименование = Истина;
		
		Запись.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезКаталог;
		
		Если Не Параметры.Свойство("Организация", Запись.Организация)
			И Не ЭлектронноеВзаимодействиеСлужебный.ИспользуетсяНесколькоОрганизаций() Тогда
			Организация = ЭлектронноеВзаимодействиеСлужебный.ОрганизацияПоУмолчанию();
			Если ЗначениеЗаполнено(Организация) Тогда
				Запись.Организация = Организация;
			Иначе
				ВызватьИсключение НСтр("ru='Необходимо ввести сведения об организации'");
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Запись.Организация) Тогда
			ПриИзмененииОрганизации(ЭтотОбъект);
		КонецЕсли;
		
		ПриСозданииЧтенииНаСервере();
		
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Элементы.КаталогОбмена.КнопкаВыбора = Ложь;
	КонецЕсли;
	
	Элементы.СпособОбменаЭД.СписокВыбора.ЗагрузитьЗначения(
		ОбменСКонтрагентамиСлужебный.СпособыПрямогоОбмена());
		
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	КонтекстныеПодсказкиБЭД.КонтекстныеПодсказки_ПриСозданииНаСервере(ЭтотОбъект, 
																		Элементы.ПанельКонтекстныхНовостей, 
																		Элементы.ГруппаКонтекстныхПодсказок);
	СформироватьКонтекст();
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	УстановитьИспользованиеАвтоНаименования(ЭтотОбъект);
	
	ЗаполнитьСписокСертификатов();
	
	Если ЗначениеЗаполнено(Запись.ИдентификаторЭДО)
		И Запись.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезFTP Тогда
		УстановитьПривилегированныйРежим(Истина);
		ЛогинFTP  = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.ИдентификаторЭДО, "ЛогинFTP");
		ПарольFTP = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.ИдентификаторЭДО, "ПарольFTP");
		УстановитьПривилегированныйРежим(Ложь);
		Если ЗначениеЗаполнено(ПарольFTP) Тогда
			ПарольFTP = ЗначениеЗаданногоПароля();;
		КонецЕсли;
	КонецЕсли;
	
	ИсходныйСпособОбмена = Запись.СпособОбменаЭД;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ИсходныйИдентификаторЭДО = Запись.ИсходныйКлючЗаписи.ИдентификаторЭДО;
	Если ЗначениеЗаполнено(ИсходныйИдентификаторЭДО)
		И ИсходныйСпособОбмена = Перечисления.СпособыОбменаЭД.ЧерезFTP
		И (ИсходныйИдентификаторЭДО <> Запись.ИдентификаторЭДО 
			ИЛИ Запись.СпособОбменаЭД <> Перечисления.СпособыОбменаЭД.ЧерезFTP) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(ИсходныйИдентификаторЭДО);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Если Запись.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезFTP Тогда
		
		Если ЛогинИзменен Тогда
			УстановитьПривилегированныйРежим(Истина);
			ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.ИдентификаторЭДО, ЛогинFTP, "ЛогинFTP");
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
		Если ПарольИзменен Тогда
			УстановитьПривилегированныйРежим(Истина);
			ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.ИдентификаторЭДО, ПарольFTP, "ПарольFTP");
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаписатьСертификатыУчетнойЗаписи(Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ИзмененСоставСертификатов = Ложь;
	УстановитьДанныеЗаголовкаСтраницыСертификаты(ЭтотОбъект);
	ИсходныйСпособОбмена = Запись.СпособОбменаЭД;
	ЛогинИзменен = Ложь;
	ПарольИзменен = Ложь;
	Если ЗначениеЗаполнено(ПарольFTP) Тогда
		ПарольFTP = ЗначениеЗаданногоПароля();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъекта(Запись.ИсходныйКлючЗаписи);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Очистить();
	
	ШаблонТекста = НСтр("ru = 'Поле ""%1"" не заполнено'");
	
	Если Не ЗначениеЗаполнено(Запись.Организация) Тогда
		ТекстСообщения = СтрШаблон(ШаблонТекста, Элементы.Организация.Заголовок);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, Элементы.Организация.ПутьКДанным,, Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Запись.НаименованиеУчетнойЗаписи) Тогда
		ТекстСообщения = СтрШаблон(ШаблонТекста, Элементы.Наименование.Заголовок);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, Элементы.Наименование.ПутьКДанным,, Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Запись.ИдентификаторЭДО) Тогда
		ТекстСообщения = СтрШаблон(ШаблонТекста, Элементы.ИдентификаторЭДО.Заголовок);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, Элементы.ИдентификаторЭДО.ПутьКДанным,, Отказ);
	КонецЕсли;
	
	Если Запись.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезКаталог Тогда
		
		Если Не ЗначениеЗаполнено(Запись.КаталогОбмена) Тогда
			ТекстСообщения = СтрШаблон(ШаблонТекста, Элементы.КаталогОбмена.Заголовок);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, Элементы.КаталогОбмена.ПутьКДанным,, Отказ);
		Иначе
			ТекстСообщения = ОбменСКонтрагентамиСлужебный.ПроверитьОбменЧерезКаталог(Запись.КаталогОбмена);
			Если ТекстСообщения <> Неопределено Тогда
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, Элементы.КаталогОбмена.ПутьКДанным,, Отказ);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли Запись.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезFTP Тогда
		
		Если Не ЗначениеЗаполнено(Запись.ПутьFTP) Тогда
			ТекстСообщения = СтрШаблон(ШаблонТекста, Элементы.ПутьFTP.Заголовок);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, Элементы.ПутьFTP.ПутьКДанным,, Отказ);
		Иначе
			
			ИсходныйИдентификаторЭДО = Запись.ИсходныйКлючЗаписи.ИдентификаторЭДО;
			Если ИсходныйСпособОбмена = Перечисления.СпособыОбменаЭД.ЧерезFTP
				И ИсходныйИдентификаторЭДО <> Запись.ИдентификаторЭДО Тогда
				ЛогинИзменен = Истина;
				ПарольИзменен = Истина;
				УстановитьПривилегированныйРежим(Истина);
				ПарольFTP = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ИсходныйИдентификаторЭДО, "ПарольFTP");
				УстановитьПривилегированныйРежим(Ложь);
			КонецЕсли;
			
			ДанныеАутентификации = Новый Структура("Логин", ЛогинFTP);
			Если ПарольИзменен Тогда
				ДанныеАутентификации.Вставить("Пароль", ПарольFTP);
			КонецЕсли;
			ТекстСообщения = ОбменСКонтрагентамиСлужебный.ПроверитьОбменЧерезFTP(Запись, ДанныеАутентификации);
			Если ТекстСообщения <> Неопределено Тогда
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, Элементы.КаталогОбмена.ПутьКДанным,, Отказ);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли Запись.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту
		И Не ЗначениеЗаполнено(Запись.УчетнаяЗаписьЭлектроннойПочты) Тогда
		ТекстСообщения = СтрШаблон(ШаблонТекста, Элементы.УчетнаяЗаписьЭлектроннойПочты.Заголовок);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, Элементы.УчетнаяЗаписьЭлектроннойПочты.ПутьКДанным,, Отказ);
	КонецЕсли;
	
	ПроверитьНаличиеДействующихСертификатов(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособОбменаПриИзменении(Элемент)
	
	ПриИзмененииСпособаОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПриИзмененииОрганизации(ЭтотОбъект);
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	ОбновляемыеКатегории = Новый Массив;
	ОбновляемыеКатегории.Добавить(КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации());
	
	СформироватьКонтекст(ОбновляемыеКатегории);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	УстановитьИспользованиеАвтоНаименования(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогОбменаПриИзменении(Элемент)
	Запись.КаталогОбмена = СокрЛП(Запись.КаталогОбмена);
КонецПроцедуры

&НаКлиенте
Процедура КаталогОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьКаталогПослеВыбораВДиалоге", ЭтотОбъект);
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбора.Заголовок = НСтр("ru = 'Выберите каталог для обмена'");
	Если ЗначениеЗаполнено(Запись.КаталогОбмена) Тогда
		ДиалогВыбора.Каталог = Запись.КаталогОбмена;
	КонецЕсли;
	ДиалогВыбора.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьFTPПриИзменении(Элемент)
	
	Запись.ПутьFTP = СокрЛП(Запись.ПутьFTP);
	
	Если ЗначениеЗаполнено(Запись.ПортFTP) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(Запись.ПутьFTP);
	Если СтруктураURI.Схема = "ftp" Тогда
		Запись.ПортFTP = 21;
	ИначеЕсли СтруктураURI.Схема = "ftps" Тогда
		Запись.ПортFTP = 990;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛогинFTPПриИзменении(Элемент)
	ЛогинИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПарольFTPПриИзменении(Элемент)
	ПарольИзменен = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокСертификатов

&НаКлиенте
Процедура СписокСертификатовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если НЕ ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции(
		"ИспользоватьЭлектронныеПодписиЭД") Тогда
		
		ТекстСообщения = ЭлектронноеВзаимодействиеСлужебныйКлиентПовтИсп.ТекстСообщенияОНеобходимостиНастройкиСистемы("ПодписаниеЭД");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Организация", Запись.Организация));
	ОткрытьФорму("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.ФормаВыбора",
		ПараметрыФормы, Элементы.СписокСертификатов);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСертификатовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ПроверитьИДобавитьСертификатВСписок(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСертификатовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСертификатовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	Модифицированность = Истина;
	ИзмененСоставСертификатов = Истина;
	
	Для Каждого Сертификат Из Элементы.СписокСертификатов.ВыделенныеСтроки Цикл
		СтрокаСертификат = Элементы.СписокСертификатов.ДанныеСтроки(Сертификат);
		СтрокаСертификат.Скрыть = Истина;
	КонецЦикла;
	
	Отбор = Новый Структура("Скрыть", Ложь);
	Элементы.СписокСертификатов.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
	
	УстановитьДанныеЗаголовкаСтраницыСертификаты(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Удалить(Команда)
	УдалитьУчетнуюЗаписьНачало();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	Если ЗначениеЗаполнено(Запись.Организация) Тогда
		Элементы.Организация.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.Организация.Гиперссылка = Истина;
	КонецЕсли;
	
	ИзмененСоставСертификатов = Ложь;
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокСертификатов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка КАК Ссылка,
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.ДействителенДо КАК ДействителенДо,
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.КемВыдан КАК КемВыдан,
		|	ВЫБОР
		|		КОГДА СертификатыКлючейЭлектроннойПодписиИШифрования.ДействителенДо >= &ТекущаяДата
		|			ТОГДА РАЗНОСТЬДАТ(&ТекущаяДата, СертификатыКлючейЭлектроннойПодписиИШифрования.ДействителенДо, ДЕНЬ)
		|		ИНАЧЕ -1
		|	КОНЕЦ КАК СрокДействияВДнях,
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Наименование КАК Представление,
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.ДействителенДо >= &ТекущаяДата КАК СертификатДействителен
		|ИЗ
		|	РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК СертификатыУчетныхЗаписейЭДО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК СертификатыКлючейЭлектроннойПодписиИШифрования
		|		ПО СертификатыУчетныхЗаписейЭДО.Сертификат = СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка
		|			И (СертификатыУчетныхЗаписейЭДО.ИдентификаторЭДО = &ИдентификаторЭДО)";
	
	Запрос.УстановитьПараметр("ИдентификаторЭДО", Запись.ИдентификаторЭДО);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТаблицаРезультат = РезультатЗапроса.Выгрузить();
	СписокСертификатов.Загрузить(ТаблицаРезультат);
	
	ЗаполнитьСрокДействияСертификата();
	
	УстановитьДанныеЗаголовкаСтраницыСертификаты(ЭтотОбъект)
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСрокДействияСертификата()
	
	Если СписокСертификатов.Количество() = 0 Тогда
		НетДействующихСертификатов = Ложь;
	Иначе
		НетДействующихСертификатов = Истина;
		Для Каждого СтрокаТаблицы Из СписокСертификатов Цикл
			
			Если СтрокаТаблицы.СрокДействияВДнях < 0 Тогда
				СрокДействия = НСтр("ru = 'Истек'");
			Иначе
				
				Если СтрокаТаблицы.СрокДействияВДнях > 30 Тогда
					НетДействующихСертификатов = Ложь;
				КонецЕсли;
				
				СрокДействия = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
					НСтр("ru = ';%1 день;;%1 дня;%1 дней;%1 дня'"),
					СтрокаТаблицы.СрокДействияВДнях);
			КонецЕсли;
			
			СтрокаТаблицы.СрокДействия = СрокДействия;
		КонецЦикла;
	КонецЕсли;
	
	Если НетДействующихСертификатов Тогда
		Элементы.СтраницаСертификаты.Картинка = БиблиотекаКартинок.ПредупреждениеКрасноеБЭД16;
	Иначе
		Элементы.СтраницаСертификаты.Картинка = Новый Картинка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииСпособаОбмена()
	
	ЗаполнитьНаименование(ЭтотОбъект);
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьИспользованиеАвтоНаименования(Форма)
	
	Форма.АвтоНаименование = ПустаяСтрока(Форма.Запись.НаименованиеУчетнойЗаписи)
		ИЛИ Форма.Запись.НаименованиеУчетнойЗаписи = СформироватьНаименование(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьНаименование(Форма)
	
	Возврат СтрШаблон(НСтр("ru = '%1, %2'"), Форма.Запись.Организация, Форма.Запись.СпособОбменаЭД);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьНаименование(Форма)
	
	Если Форма.АвтоНаименование
		И ЗначениеЗаполнено(Форма.Запись.СпособОбменаЭД)
		И ЗначениеЗаполнено(Форма.Запись.Организация) Тогда
		Форма.Запись.НаименованиеУчетнойЗаписи = СформироватьНаименование(Форма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДанныеЗаголовкаСтраницыСертификаты(Форма)
	
	Отбор = Новый Структура("Скрыть", Ложь);
	КоличествоСертификатов = Форма.СписокСертификатов.НайтиСтроки(Отбор).Количество();
	Если КоличествоСертификатов = 0 Тогда
		Форма.ЗаголовокСтраницыСертификаты = "";
		Возврат;
	КонецЕсли;
	
	Форма.ЗаголовокСтраницыСертификаты = КоличествоСертификатов;
	Если Форма.ИзмененСоставСертификатов Тогда
		Форма.ЗаголовокСтраницыСертификаты = Форма.ЗаголовокСтраницыСертификаты + "*";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.ГруппаОбменЧерезКаталог.Видимость = Запись.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезКаталог;
	Элементы.ГруппаОбменЧерезFTP.Видимость = Запись.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезFTP;
	Элементы.ГруппаОбменЧерезПочту.Видимость = Запись.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииОрганизации(Форма)
	
	Запись = Форма.Запись;
	
	ЗаполнитьНаименование(Форма);
	Если ЗначениеЗаполнено(Запись.Организация) Тогда
		Запись.ИдентификаторЭДО = Строка(Запись.Организация.УникальныйИдентификатор());
	Иначе
		Запись.ИдентификаторЭДО = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКаталогПослеВыбораВДиалоге(Результат, Контекст) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Запись.КаталогОбмена = Результат[0];
	КонецЕсли;
	
КонецПроцедуры

#Область ПроверкаСертификатовПередДобавлением

&НаКлиенте
Процедура ПроверитьИДобавитьСертификатВСписок(Сертификат)
	
	МассивСтрок = СписокСертификатов.НайтиСтроки(Новый Структура("Ссылка", Сертификат));
	Если МассивСтрок.Количество() > 0 И Не МассивСтрок[0].Скрыть Тогда
		ТекстПредупреждения = НСтр("ru = 'Выбранный сертификат уже добавлен для учетной записи ЭДО'");
		ПоказатьПредупреждение(, ТекстПредупреждения, 30);
		Возврат;
	КонецЕсли;
	
	РезультатПроверки = ПроверитьСертификатДляУчетнойЗаписи(Сертификат, Запись.Организация);
	
	Если РезультатПроверки.Статус Тогда
		ДобавитьСертификатВСписок(Сертификат);
	Иначе
		МассивПредупреждений = Новый Массив;
		Для Каждого ОписаниеОшибки Из РезультатПроверки.Ошибки Цикл
			Если ОписаниеОшибки.Тип = "Предупреждение" Тогда
				МассивПредупреждений.Добавить(ОписаниеОшибки.Текст);
			Иначе
				ОбщегоНазначенияКлиент.СообщитьПользователю(ОписаниеОшибки.Текст);
				Возврат;
			КонецЕсли;
		КонецЦикла;
		
		МассивПредупреждений.Добавить(НСтр("ru = 'Продолжить регистрацию сертификата?'"));
		ТекстВопроса = СтрСоединить(МассивПредупреждений, Символы.ПС);
		
		Оповещение = Новый ОписаниеОповещения("ДобавитьСертификатВСписокПослеПодтверждения", ЭтотОбъект, Сертификат);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьСертификатДляУчетнойЗаписи(Знач Сертификат, Знач Организация)
	Возврат ОбменСКонтрагентамиСлужебный.ПроверитьСертификатДляУчетнойЗаписи(Сертификат, Организация);
КонецФункции

&НаКлиенте
Процедура ДобавитьСертификатВСписокПослеПодтверждения(Ответ, Сертификат) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ДобавитьСертификатВСписок(Сертификат);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ДобавитьСертификатВСписок(Сертификат)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка КАК Ссылка,
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.ДействителенДо КАК ДействителенДо,
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.КемВыдан КАК КемВыдан,
		|	ВЫБОР
		|		КОГДА СертификатыКлючейЭлектроннойПодписиИШифрования.ДействителенДо >= &ТекущаяДата
		|			ТОГДА РАЗНОСТЬДАТ(&ТекущаяДата, СертификатыКлючейЭлектроннойПодписиИШифрования.ДействителенДо, ДЕНЬ)
		|		ИНАЧЕ -1
		|	КОНЕЦ КАК СрокДействияВДнях,
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Наименование КАК Представление,
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.ДействителенДо >= &ТекущаяДата КАК СертификатДействителен
		|ИЗ
		|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК СертификатыКлючейЭлектроннойПодписиИШифрования
		|ГДЕ
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка = &Сертификат";
	
	Запрос.УстановитьПараметр("Сертификат" , Сертификат);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокиСертификата = СписокСертификатов.НайтиСтроки(Новый Структура("Ссылка", Сертификат));
		Если СтрокиСертификата.Количество() = 0 Тогда
			СтрокаСертификата = СписокСертификатов.Добавить();
		Иначе
			СтрокаСертификата = СтрокиСертификата[0];
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаСертификата, Выборка);
		СтрокаСертификата.Скрыть = Ложь;
		
	КонецЦикла;
	
	ЗаполнитьСрокДействияСертификата();
	
	ИзмененСоставСертификатов = Истина;
	
	УстановитьДанныеЗаголовкаСтраницыСертификаты(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаписатьСертификатыУчетнойЗаписи(Отказ)
	
	ИсходныйИдентификаторЭДО = Запись.ИсходныйКлючЗаписи.ИдентификаторЭДО;
	Если Не ЗначениеЗаполнено(ИсходныйИдентификаторЭДО) Тогда
		ИсходныйИдентификаторЭДО = Запись.ИдентификаторЭДО;
	КонецЕсли;
	
	Если ИсходныйИдентификаторЭДО <> Запись.ИдентификаторЭДО Тогда
		ПроверитьУникальностьИдентификатораЭДОВРегистреСертификатов(Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли Не ИзмененСоставСертификатов Тогда
		Возврат;
	КонецЕсли;
	
	БлокировкаДанных = Новый БлокировкаДанных;
	ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.СертификатыУчетныхЗаписейЭДО");
	ЭлементБлокировкиДанных.УстановитьЗначение("ИдентификаторЭДО", ИсходныйИдентификаторЭДО);
	ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
	БлокировкаДанных.Заблокировать();
	
	НаборЗаписей = РегистрыСведений.СертификатыУчетныхЗаписейЭДО.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторЭДО.Установить(ИсходныйИдентификаторЭДО);
	
	СертификатыДляЗаписи = СписокСертификатов.Выгрузить(Новый Структура("Скрыть", Ложь));
	Для Каждого ПараметрыСертификата Из СертификатыДляЗаписи Цикл
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаписьНабора.ИдентификаторЭДО = Запись.ИдентификаторЭДО;
		ЗаписьНабора.Сертификат       = ПараметрыСертификата.Ссылка;
		ЗаписьНабора.ДействителенДо   = ПараметрыСертификата.ДействителенДо;
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьУникальностьИдентификатораЭДОВРегистреСертификатов(Отказ)
	
	БлокировкаДанных = Новый БлокировкаДанных;
	ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.СертификатыУчетныхЗаписейЭДО");
	ЭлементБлокировкиДанных.УстановитьЗначение("ИдентификаторЭДО", Запись.ИдентификаторЭДО);
	ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
	БлокировкаДанных.Заблокировать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА КАК Выбран
		|ИЗ
		|	РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК СертификатыУчетныхЗаписейЭДО
		|ГДЕ
		|	СертификатыУчетныхЗаписейЭДО.ИдентификаторЭДО = &ИдентификаторЭДО";
	
	Запрос.УстановитьПараметр("ИдентификаторЭДО", Запись.ИдентификаторЭДО);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьУчетнуюЗаписьНачало()
	Оповещение = Новый ОписаниеОповещения("УдалитьУчетнуюЗаписьПослеВопроса", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Сейчас будет удалена учетная запись ЭДО. Также будут удалены настройки отправки и получения, связанные с этой учетной записью.
		|Продолжить?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьУчетнуюЗаписьПослеВопроса(Ответ, Контекст) Экспорт
	
	Модифицированность = Ложь;
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьУчетнуюЗаписьНаСервере(Запись.ИдентификаторЭДО);
	
	ОповеститьОбИзмененииУчетнойЗаписи();
	
	Закрыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьУчетнуюЗаписьНаСервере(Знач ИдентификаторЭДО)
	
	ПараметрыПроцедуры = Новый Структура("ИдентификаторЭДО", ИдентификаторЭДО);
	РегистрыСведений.УчетныеЗаписиЭДО.УдалитьУчетнуюЗаписьЭДО(ПараметрыПроцедуры);
	
КонецПроцедуры

&НаСервере
Функция ЗначениеЗаданногоПароля()
	Возврат " ";
КонецФункции

&НаКлиенте
Процедура ОповеститьОбИзмененииУчетнойЗаписи()
	КлючЗаписи = ОбменСКонтрагентамиСлужебныйКлиент.КлючУчетнойЗаписиЭДО(Запись.ИдентификаторЭДО);
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъекта(КлючЗаписи);
КонецПроцедуры

&НаСервере
Процедура ПроверитьНаличиеДействующихСертификатов(Отказ)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныеПодписиЭД") Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкиСИспользованиемПодписиОтсутствуют() Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныеСертификаты = СписокСертификатов.НайтиСтроки(Новый Структура("Скрыть", Ложь));
	Если ВыбранныеСертификаты.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Нет доступных сертификатов'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "СписокСертификатов",,Отказ);
	Иначе
		ЕстьДействующиеСертификаты = Ложь;
		Для каждого СтрокаСертификата Из ВыбранныеСертификаты Цикл
			Если СтрокаСертификата.СертификатДействителен Тогда
				ЕстьДействующиеСертификаты = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не ЕстьДействующиеСертификаты Тогда
			ТекстСообщения = НСтр("ru = 'Нет действующих сертификатов.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "СписокСертификатов",,Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НастройкиСИспользованиемПодписиОтсутствуют()
	
	ИсходныйИдентификаторЭДО = Запись.ИсходныйКлючЗаписи.ИдентификаторЭДО;
	Если Не ЗначениеЗаполнено(ИсходныйИдентификаторЭДО) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК Выбран
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам КАК НастройкиОтправкиЭлектронныхДокументовПоВидам
		|ГДЕ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторОтправителя = &ИдентификаторЭДО
		|	И НЕ НастройкиОтправкиЭлектронныхДокументовПоВидам.ОбменБезПодписи";
	
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ИсходныйИдентификаторЭДО);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатЗапроса.Пустой();
	
КонецФункции

#Область КонтекстныеПодсказки

&НаКлиенте
Процедура Подключаемый_ПанельКонтекстныхНовостей_ЭлементУправленияНажатие(Элемент)
	
	КонтекстныеПодсказкиБЭДКлиент.ЭлементУправленияНажатие(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьКонтекст(КатегорииПересчета = Неопределено)
	
	Если Не КонтекстныеПодсказкиБЭД.ФункционалКонтекстныхПодсказокДоступен() Тогда 
		Возврат;
	КонецЕсли;
	
	Категория = КонтекстныеПодсказкиБЭДКатегоризацияВызовСервера.Категория_КодОператораУчетнойЗаписиОрганизации();
	Если ЗначениеЗаполнено(Категория)  
			И ?(ЗначениеЗаполнено(КатегорииПересчета), КатегорииПересчета.Найти(Категория) <> Неопределено, Истина) Тогда 
		Значение = КонтекстныеПодсказкиБЭДКатегоризация.КодОператораУчетнойЗаписиОрганизации(Запись.Организация); 
		КонтекстныеПодсказкиБЭДКлиентСервер.УстановитьЗначениеКатегорииКонтекстаФормы(ЭтаФорма, Категория, Значение);
	КонецЕсли;

	КонтекстныеПодсказкиБЭД.ОтобразитьАктуальныеДляКонтекстаНовости(ЭтотОбъект);
	
КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные).
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";	
	КонтекстныеПодсказкиБЭДКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПанельКонтекстныхНовостейОбработкаНавигационнойСсылки(Элемент, ПараметрНавигационнаяСсылка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	КонтекстныеПодсказкиБЭДКлиент.ПанельКонтекстныхНовостей_ЭлементПанелиНовостейОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		ПараметрНавигационнаяСсылка,
		СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти 


#КонецОбласти