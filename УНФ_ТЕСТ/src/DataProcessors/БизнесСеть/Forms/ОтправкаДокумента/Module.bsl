
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.МассивСсылокНаОбъект) <> Тип("Массив") ИЛИ Параметры.МассивСсылокНаОбъект.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Ссылка = Параметры.МассивСсылокНаОбъект[0];
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	МассивСсылокНаОбъект = Параметры.МассивСсылокНаОбъект;
	РеквизитыДокумента = ОбменСКонтрагентамиСлужебный.ЗаполнитьПараметрыЭДПоИсточнику(Ссылка);
	Организация = РеквизитыДокумента.Организация;
	Контрагент = РеквизитыДокумента.Контрагент;
	ЭлектронныйАдресУведомления = ""; 
	ОбменСКонтрагентамиПереопределяемый.АдресЭлектроннойПочтыКонтрагента(РеквизитыДокумента.Контрагент, ЭлектронныйАдресУведомления);
	
	ЭДНадпись = Ссылка.Метаданные().Синоним + " " + Ссылка.Номер + " " + Формат(Ссылка.Дата, "ДЛФ=D");
	
	ТекстОрганизации = НСтр("ru = 'Для отправки документа подключите организацию %1 к сервису 1С:Бизнес-сеть.'");
	ТекстОрганизации = СтрШаблон(ТекстОрганизации, Организация);
	Элементы.ТекстРегистрацииОрганизации.Заголовок = ТекстОрганизации;
	
	ТекстКонтрагента = НСтр("ru = 'Контрагент ""%1"" не зарегистрирован в сервисе 1С:Бизнес-сеть.'");
	ТекстКонтрагента = СтрШаблон(ТекстКонтрагента, Контрагент);
	Элементы.ТекстРегистрацииКонтрагента.Заголовок = ТекстКонтрагента;
	
	// Формирование электронных документов.
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("МассивСсылокНаОбъект", МассивСсылокНаОбъект);
	ПараметрыЗадания.Вставить("ОтправкаЧерезБС", Истина);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	Обработки.ОбменСКонтрагентами.ПодготовитьДанныеДляЗаполненияДокументов(ПараметрыЗадания, АдресХранилища);
	
	Если АдресХранилища = "" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗагрузитьПодготовленныеДанныеЭД();
	
	Если ОбменСКонтрагентами.ОрганизацияПодключена(Организация) Тогда
		Элементы.ДекорацияПодключенияЭДО.Видимость = Ложь;
	КонецЕсли;
	
	// Проверка организации.
	ОрганизацияЗарегистрирована = БизнесСеть.ОрганизацияПодключена(Организация);
	
	Если ОрганизацияЗарегистрирована Тогда
		ЕстьПодключениеКСервису = Истина;
	Иначе
		ЕстьПодключениеКСервису = БизнесСеть.ОрганизацияПодключена();
	КонецЕсли;
	
	Если ЕстьПодключениеКСервису Тогда
		КонтрагентЗарегистрирован = КонтрагентЗарегистрирован(Организация, Контрагент, Отказ);
	КонецЕсли;
	
	Если ОрганизацияЗарегистрирована И КонтрагентЗарегистрирован Тогда
		КлючСохраненияПоложенияОкна = "БизнесСеть_ОтправкаДокумента_Стандартный";
	ИначеЕсли ОрганизацияЗарегистрирована И Не КонтрагентЗарегистрирован Тогда
		КлючСохраненияПоложенияОкна = "БизнесСеть_ОтправкаДокумента_РегистрацияКонтрагента";
	ИначеЕсли Не ОрганизацияЗарегистрирована И КонтрагентЗарегистрирован Тогда
		КлючСохраненияПоложенияОкна = "БизнесСеть_ОтправкаДокумента_РегистрацияОрганизации";
	Иначе
		КлючСохраненияПоложенияОкна = "БизнесСеть_ОтправкаДокумента_РегистрацияОрганизацииКонтрагента";
	КонецЕсли;
	
	Если ОрганизацияЗарегистрирована Тогда
		ОбновитьСписокИсторииОтправки(Отказ);
	КонецЕсли;
	
	СтруктураКонтактныхДанных = БизнесСеть.ОписаниеКонтактнойИнформацииПользователя();
	БизнесСетьПереопределяемый.ПолучитьКонтактнуюИнформациюПользователя(Пользователи.ТекущийПользователь(), СтруктураКонтактныхДанных);
	КонтактноеЛицо = СтруктураКонтактныхДанных.ФИО;
	Телефон = СтруктураКонтактныхДанных.Телефон;
	ЭлектроннаяПочта = СтруктураКонтактныхДанных.ЭлектроннаяПочта;
	
	ИзменитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не НаправитьУведомление Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ЭлектронныйАдресУведомления"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесСетьСлужебныйКлиент.ОткрытьПрофильУчастника(Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОчиститьСообщения();
	
	Если СписокИстории.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтруктур = Новый Массив;
	ЗаполнитьСписокДокументовИстории(МассивСтруктур);
	
	Если МассивСтруктур.Количество() = 1 Тогда
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ПросмотрДокумента",
			Новый Структура("СтруктураЭД", МассивСтруктур[0]), ЭтотОбъект);
	Иначе
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("СтруктураЭД", МассивСтруктур);
		ПараметрыОткрытия.Вставить("РежимПросмотраИстории", Истина);
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ИсторияОтправки", ПараметрыОткрытия, ЭтотОбъект);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДокументНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОчиститьСообщения();
	
	Если ТаблицаДанных.Количество() > 1 Тогда
		
		МассивСтруктур = Новый Массив;
		Для каждого СтрокаДанных Из ТаблицаДанных Цикл
			ПараметрыЭД = НовыеПараметрыДокумента();
			ПараметрыЭД.АдресХранилища    = СтрокаДанных.АдресХранилища;
			ПараметрыЭД.ФайлАрхива        = Истина;
			ПараметрыЭД.НаименованиеФайла = СтрокаДанных.НаименованиеФайла;
			ПараметрыЭД.НаправлениеЭД     = СтрокаДанных.НаправлениеЭД;
			ПараметрыЭД.Контрагент        = СтрокаДанных.Контрагент;
			ПараметрыЭД.ВладелецЭД        = СтрокаДанных.ВладелецЭД;
			ПараметрыЭД.Источник          = СтрокаДанных.Источник;
			МассивСтруктур.Добавить(ПараметрыЭД);
		КонецЦикла;
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ИсторияОтправки",
			Новый Структура("СтруктураЭД", МассивСтруктур), ЭтотОбъект);
			
	ИначеЕсли ТаблицаДанных.Количество() = 1 Тогда
		ПараметрыЭД = НовыеПараметрыДокумента(Истина);
		ПараметрыЭД.ФайлАрхива = Истина;
		ПараметрыЭД.СопроводительнаяИнформация = СопроводительнаяИнформация;
		ЗаполнитьЗначенияСвойств(ПараметрыЭД, ТаблицаДанных[0]);
		ПараметрыФормы = Новый Структура("СтруктураЭД", ПараметрыЭД);
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ПросмотрДокумента", ПараметрыФормы, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаправитьУведомлениеПриИзменении(Элемент)
	
	Элементы.ЭлектронныйАдресУведомления.Доступность = НаправитьУведомление;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектроннаяПочтаПриИзменении(Элемент)
	
	УстановитьДоступностьФлагаУведомлятьПоПочте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьДокумент(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ЭлектроннаяПочта)
		И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектроннаяПочта, Истина) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Адрес электронной почты введен неверно'"),,
			"ЭлектроннаяПочта",,);
		Возврат;
	КонецЕсли;
	
	Если НаправитьУведомление И Не ПустаяСтрока(ЭлектронныйАдресУведомления)
		И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектронныйАдресУведомления, Истина) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Адрес электронной почты контрагента введен неверно'"),,
			"ЭлектронныйАдресУведомления",,);
		Возврат;
	КонецЕсли;
	
	ОтправитьДокументыВСервис();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьОрганизацию(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПодключитьОрганизациюПродолжение", ЭтотОбъект);
	
	БизнесСетьСлужебныйКлиент.ОткрытьФормуПодключенияОрганизации(Организация, ЭтотОбъект, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция КонтрагентЗарегистрирован(Организация, Контрагент, Отказ)
	
	ПараметрыМетода = БизнесСетьКлиентСервер.ОписаниеИдентификацииОрганизацииКонтрагентов();
	ПараметрыМетода.Ссылка      = Контрагент;
	ПараметрыМетода.Организация = Организация;
	
	ДанныеСервиса = БизнесСеть.РеквизитыУчастника(ПараметрыМетода, Отказ);
	
	Результат = Ложь;
	
	Если Не Отказ И ЗначениеЗаполнено(ДанныеСервиса) Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПодключитьОрганизациюПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.СтатусПодключения = "Подключена" Тогда
		ПодключитьОрганизациюПродолжениеНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодключитьОрганизациюПродолжениеНаСервере()
	
	ОрганизацияЗарегистрирована         = Истина;
	ЕстьПодключениеКСервису             = Истина;
	Элементы.Зарегистрировать.Видимость = Ложь;
	
	Отказ = Ложь;
	
	// Проверка регистрации контрагента.
	КонтрагентЗарегистрирован = КонтрагентЗарегистрирован(Организация, Контрагент, Отказ);
	
	// Обновление истории отправки.
	ОбновитьСписокИсторииОтправки(Отказ);
	
	// Обновление видимости элементов.
	ИзменитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеЭД()
	
	ТаблицаЭД = БизнесСеть.ПолучитьУдалитьИзВременногоХранилища(АдресХранилища);
	
	Если НЕ ЗначениеЗаполнено(ТаблицаЭД) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из ТаблицаЭД Цикл
		СтрокаТаблицы.АдресХранилища = ПоместитьВоВременноеХранилище(СтрокаТаблицы.ДвоичныеДанныеПакета, УникальныйИдентификатор);
		СтрокаТаблицы.АдресХранилищаПредставления = ПоместитьВоВременноеХранилище(СтрокаТаблицы.ДвоичныеДанныеПредставления,
			УникальныйИдентификатор);
	КонецЦикла;
	
	ТипыДокументов = БизнесСеть.ВидыДокументовСервиса();
	
	ТаблицаДанных.Загрузить(ТаблицаЭД);
	Для каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаТаблицы.ВладелецЭД, "Номер, Дата");
		ШаблонНаименования = НСтр("ru = '%1 %2 от %3'");
		
		Тип = ТипыДокументов.НайтиПоЗначению(СтрокаТаблицы.ВидЭД);
		Если Тип = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Отправка данного вида документа не поддерживается.'");
		КонецЕсли;
		
		НомерДокумента = ""; 
		ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьПечатныйНомерДокумента(СтрокаТаблицы.ВладелецЭД, НомерДокумента);
		
		СтрокаТаблицы.НаименованиеФайла = СтрШаблон(ШаблонНаименования,
			Тип.Представление, СокрП(НомерДокумента), Формат(СтруктураРеквизитов.Дата, "ДЛФ=Д"));
	КонецЦикла;
	
	ТекстГиперссылки = НСтр("ru = 'документы не найдены'");
	Если ТаблицаДанных.Количество() > 1 Тогда
		ТекстГиперссылки = НСтр("ru = 'открыть список (%1)'");
		ТекстГиперссылки = СтрЗаменить(ТекстГиперссылки, "%1", ТаблицаДанных.Количество());
	ИначеЕсли ТаблицаДанных.Количество() = 1 Тогда
		ТекстГиперссылки = ТаблицаДанных[0].НаименованиеФайла;
	КонецЕсли;
	ЭДНадпись = ТекстГиперссылки;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьДоступностьЭлементов()
	
	Элементы.РегистрацияОрганизации.Видимость = Не ОрганизацияЗарегистрирована;
	Элементы.РегистрацияКонтрагента.Видимость = Не КонтрагентЗарегистрирован И ЕстьПодключениеКСервису;
	Элементы.Контрагент.Видимость = КонтрагентЗарегистрирован;
	
	Элементы.Зарегистрировать.Видимость = Не ОрганизацияЗарегистрирована;
	
	Если Не ОрганизацияЗарегистрирована И Не КонтрагентЗарегистрирован Тогда
		Элементы.ТекстРегистрацииКонтрагента.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.ЧертаСверху, 1);
	КонецЕсли;
	
	ТребуетсяОтправкаУведомления = НЕ КонтрагентЗарегистрирован И ЗначениеЗаполнено(ЭлектронныйАдресУведомления);
	НаправитьУведомление = ТребуетсяОтправкаУведомления;
	Элементы.ЭлектронныйАдресУведомления.Доступность = ТребуетсяОтправкаУведомления;
	
	Если СписокИстории.Количество() = 0 Тогда
		Элементы.История.Гиперссылка = Ложь;
		Состояние = НСтр("ru = 'не отправлен'");
	ИначеЕсли СписокИстории.Количество() = 1 Тогда
		Элементы.История.Гиперссылка = Истина;
		ОтправленныеДанные = СписокИстории[0];
		Если ВРег(ОтправленныеДанные.Статус) = "ДОСТАВЛЕН" Тогда
			Состояние = НСтр("ru = 'доставлен'") + " " + Формат(ОтправленныеДанные.ДатаДоставки, "ДЛФ=D");
		Иначе
			Состояние = НСтр("ru = 'отправлен'") + " " + Формат(ОтправленныеДанные.Дата, "ДЛФ=D");
		КонецЕсли;
	Иначе
		Элементы.История.Гиперссылка = Истина;	
		ШаблонСостояния = НСтр("ru = 'отправлено (%1)'");
		Состояние = СтрШаблон(ШаблонСостояния, СписокИстории.Количество());
	КонецЕсли;
	
	Элементы.Отправить.Доступность = ОрганизацияЗарегистрирована;
	
	Элементы.УведомлятьПоПочте.Доступность = Не ПустаяСтрока(ЭлектроннаяПочта);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьДокументыВСервис()
	
	Отказ = Ложь;
	ОтправитьДокументыНаСервере(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОповещения	= НСтр("ru = 'Отправка выполнена.'");
	ТекстПояснения	= НСтр("ru = 'Отправлен документ через сервис 1С:Бизнес-сеть.'");
	ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(Ссылка),
		ТекстПояснения, БиблиотекаКартинок.БизнесСеть);
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьДокументыНаСервере(Отказ)
	
	Если Не БизнесСеть.ОрганизацияПодключена(Организация) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МассивИдентификаторов = Новый Массив;
	
	Для каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		// Отправка документов.
		ПараметрыКоманды = Новый Структура;
		ПараметрыКоманды.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
		ПараметрыКоманды.Вставить("Отправитель", Организация);
		ПараметрыКоманды.Вставить("Получатель",  Контрагент);
		ПараметрыКоманды.Вставить("Заголовок",   СтрокаТаблицы.НаименованиеФайла);
		ПараметрыКоманды.Вставить("Ссылка",      СтрокаТаблицы.ВладелецЭД);
		ПараметрыКоманды.Вставить("ВидЭД",       СтрокаТаблицы.ВидЭД);
		ПараметрыКоманды.Вставить("Сумма",       СтрокаТаблицы.Сумма);
		ПараметрыКоманды.Вставить("АдресХранилища",    СтрокаТаблицы.АдресХранилища);
		ПараметрыКоманды.Вставить("ТипПредставления",  СтрокаТаблицы.ТипПредставления);
		ПараметрыКоманды.Вставить("СопроводительнаяИнформация",  СопроводительнаяИнформация);
		ПараметрыКоманды.Вставить("АдресХранилищаПредставления", СтрокаТаблицы.АдресХранилищаПредставления);
		ПараметрыКоманды.Вставить("КонтактноеЛицо",    КонтактноеЛицо);
		ПараметрыКоманды.Вставить("Телефон",           Телефон);
		ПараметрыКоманды.Вставить("ЭлектроннаяПочта",  ЭлектроннаяПочта);
		ПараметрыКоманды.Вставить("УведомлятьПоПочте", УведомлятьПоПочте);
		ПараметрыВызова = БизнесСеть.ПараметрыКомандыОтправитьДокумент(ПараметрыКоманды, Отказ);
		Результат = БизнесСеть.ВыполнитьКомандуСервиса(ПараметрыВызова, Отказ);
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		МассивИдентификаторов.Добавить(Результат);
		
	КонецЦикла;
	
	Если Не Отказ Тогда
		// Направление уведомления об отправке электронного документа через сервис.
		Если НаправитьУведомление Тогда
			
			Результат = БизнесСеть.ОтправитьУведомлениеОбОтправке(
				Организация, 
				Контрагент, 
				МассивИдентификаторов,
				ЭлектронныйАдресУведомления, 
				Отказ);
				
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДокументовИстории(МассивСтруктур)
	
	МассивИдентификаторовДокументов = Новый Массив;
	Для каждого СтрокаДанных Из СписокИстории Цикл
		МассивИдентификаторовДокументов.Добавить(СтрокаДанных.Идентификатор);
	КонецЦикла;
	
	МассивДанныхДокументов = БизнесСетьВызовСервера.ПолучитьДанныеДокументаСервиса(
		Организация, МассивИдентификаторовДокументов, Ложь, УникальныйИдентификатор);
	
	МассивСтруктур = Новый Массив;
	Для каждого СтрокаДанных Из СписокИстории Цикл
		ПараметрыДокумента = НовыеПараметрыДокумента(Истина);
		ЗаполнитьЗначенияСвойств(ПараметрыДокумента, СтрокаДанных);
		
		// Заполнение дополнительных параметров.
		АдресХранилища = МассивДанныхДокументов[СписокИстории.Индекс(СтрокаДанных)];
		ПараметрыДокумента.Вставить("АдресХранилища",    АдресХранилища);
		ПараметрыДокумента.Вставить("ФайлАрхива",        Истина);
		ПараметрыДокумента.Вставить("НаименованиеФайла", СтрокаДанных.Наименование);
		ПараметрыДокумента.Вставить("Контрагент",        Контрагент);
		ПараметрыДокумента.Вставить("НаправлениеЭД",     ПредопределенноеЗначение("Перечисление.НаправленияЭД.Исходящий"));
		
		МассивСтруктур.Добавить(ПараметрыДокумента);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПодключенияЭДООбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СпособыОбмена = Новый Массив;
	СпособыОбмена.Добавить(ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезСервис1СЭДО"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СпособыОбменаЭД", СпособыОбмена);
	ПараметрыФормы.Вставить("Организация",     Организация);
	ОчиститьСообщения();
	ОткрытьФорму("РегистрСведений.УчетныеЗаписиЭДО.Форма.ПомощникПодключенияЭДО", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьФлагаУведомлятьПоПочте()
	
	Элементы.УведомлятьПоПочте.Доступность = Не ПустаяСтрока(ЭлектроннаяПочта);
	Если Не Элементы.УведомлятьПоПочте.Доступность Тогда
		УведомлятьПоПочте = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокИсторииОтправки(Отказ)
	
	ИдентификаторОрганизации = БизнесСеть.ИдентификаторОрганизации(Организация);
	
	СписокИстории.Очистить();
	Для каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		// Загрузка истории отправки документа.
		ПараметрыМетода = Новый Структура;
		
		ПараметрыМетода.Вставить("ИдентификаторОрганизации", ИдентификаторОрганизации);
		ПараметрыМетода.Вставить("МассивСсылокНаОбъект",    ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокаТаблицы.ВладелецЭД));
		ПараметрыМетода.Вставить("РежимВходящихДокументов", Ложь);
		ПараметрыМетода.Вставить("ВозвращатьДанные",        Ложь);
		ПараметрыКоманды = БизнесСеть.ПараметрыКомандыПолучитьДокументы(ПараметрыМетода, Истина, Отказ);
		ДанныеСервиса    = БизнесСеть.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);
		
		Если Отказ Тогда
			Прервать;
		ИначеЕсли ДанныеСервиса = Неопределено Или ТипЗнч(ДанныеСервиса) <> Тип("Массив") Тогда
			Продолжить;
		КонецЕсли;
		
		Для каждого ЭлементКоллекции Из ДанныеСервиса Цикл
			
			НоваяСтрока = СписокИстории.Добавить();
			НоваяСтрока.Дата = БизнесСетьКлиентСервер.ДатаИзUnixTime(ЭлементКоллекции.sentDate);
			Если ВРег(ЭлементКоллекции.deliveryStatus) = "SENT" Тогда
				НоваяСтрока.Статус = НСтр("ru = 'Отправлен'");
			ИначеЕсли ВРег(ЭлементКоллекции.deliveryStatus) = "DELIVERED" Тогда
				НоваяСтрока.Статус = НСтр("ru = 'Доставлен'");
			ИначеЕсли ВРег(ЭлементКоллекции.deliveryStatus) = "REJECTED" Тогда
				НоваяСтрока.Статус = НСтр("ru = 'Отклонен'");
			КонецЕсли; 
			
			НоваяСтрока.Наименование  = ЭлементКоллекции.documentTitle;
			НоваяСтрока.Идентификатор = ЭлементКоллекции.id;
			Если ЗначениеЗаполнено(ЭлементКоллекции.receivedDate) Тогда
				НоваяСтрока.ДатаДоставки = БизнесСетьКлиентСервер.ДатаИзUnixTime(ЭлементКоллекции.receivedDate);
			КонецЕсли;
			
			// Получение владельца электронного документа..
			СтрокаДанных = ТаблицаДанных.НайтиСтроки(Новый Структура("УникальныйИдентификатор", ЭлементКоллекции.documentGuid));
			НоваяСтрока.ВладелецЭД = СтрокаДанных[0].ВладелецЭД;
			
			// Заполнение дополнительной информации.
			НоваяСтрока.Информация    = ЭлементКоллекции.info;
			НоваяСтрока.Получатель    = ЭлементКоллекции.destinationOrganization.title;
			НоваяСтрока.КонтрагентИНН = ЭлементКоллекции.destinationOrganization.inn;
			НоваяСтрока.КонтрагентКПП = ЭлементКоллекции.destinationOrganization.kpp;
			
			// Удаление двоичных данных из структуры данных.
			НоваяСтрока.Источник = ЭлементКоллекции;
			Если НоваяСтрока.Источник.Свойство("documentData") Тогда
				НоваяСтрока.Источник.Удалить("documentData");
			КонецЕсли;
			Если НоваяСтрока.Источник.Свойство("documentPresentationData") Тогда
				НоваяСтрока.Источник.Удалить("documentPresentationData");	
			КонецЕсли;
			
			НоваяСтрока.КонтактноеЛицо   = ЭлементКоллекции.person.name;
			НоваяСтрока.ЭлектроннаяПочта = ЭлементКоллекции.person.email;
			НоваяСтрока.Телефон = ЭлементКоллекции.person.phone;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НовыеПараметрыДокумента(РасширенныеДанные = Ложь)
	
	Результат = Новый Структура;
	Результат.Вставить("АдресХранилища",    "");
	Результат.Вставить("ФайлАрхива",        Ложь);
	Результат.Вставить("НаименованиеФайла", "");
	Результат.Вставить("НаправлениеЭД");
	Результат.Вставить("Контрагент");
	Результат.Вставить("ВладелецЭД");
	Результат.Вставить("Источник");
	Результат.Вставить("СопроводительнаяИнформация", "");
	Результат.Вставить("УникальныйИдентификатор",    "");
	
	Если РасширенныеДанные Тогда
		Результат.Вставить("Дата",          Дата(1,1,1));
		Результат.Вставить("Статус");
		Результат.Вставить("Идентификатор");
		Результат.Вставить("Получатель");
		Результат.Вставить("Информация");
		Результат.Вставить("КонтрагентИНН", "");
		Результат.Вставить("КонтрагентКПП", "");
		Результат.Вставить("ДатаДоставки",  Дата(1,1,1));
		Результат.Вставить("КонтактноеЛицо");
		Результат.Вставить("Телефон");
		Результат.Вставить("ЭлектроннаяПочта");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
