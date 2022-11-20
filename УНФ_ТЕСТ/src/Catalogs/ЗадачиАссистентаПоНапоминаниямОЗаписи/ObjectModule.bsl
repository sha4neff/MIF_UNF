#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Автор) Тогда
		Автор = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = Ложь;
	ДополнительныеСвойства.Свойство("ЭтоНовый", ЭтоНовый);
	
	Если Не ЭтоНовый Тогда
		АссистентУправления.УдалитьЗапланированныеЗаписиЗадачи(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПередВыполнениемЗадачи(Предмет, Источник, ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

Процедура ВыполнитьЗадачу(Предмет, Источник, ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	Если СпособОповещения = Перечисления.ВидыКаналовСвязи.Email Тогда
		НовоеСобытие = СоздатьEmail(Предмет, ДополнительныеПараметры);
	ИначеЕсли СпособОповещения = Перечисления.ВидыКаналовСвязи.SMS Тогда
		НовоеСобытие = СоздатьSMS(Предмет, ДополнительныеПараметры);
	Иначе
		ТекстОшибки = СтрШаблон(
			НСтр("ru='Не определена реализация метода ""ВыполнитьЗадачу"" для способа оповещения ""%1""'"),
			СпособОповещения);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("СозданноеСобытие", НовоеСобытие);
	
КонецПроцедуры

Процедура ПослеВыполненияЗадачи(Предмет, Источник, ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	Если ПараметрыВыполнения.ЗадачаВыполненаУспешно И ДополнительныеПараметры.Свойство("СозданноеСобытие") Тогда
		ОтправитьСобытие(ДополнительныеПараметры.СозданноеСобытие);
		ДобавитьСообщениеАссистентаПоРезультатуВыполненияВПредмет(Предмет, ДополнительныеПараметры.СозданноеСобытие);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КонтактИзПредмета(Предмет)
	
	Если ТипЗнч(Предмет) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Предмет, "Контрагент");
	ИначеЕсли ТипЗнч(Предмет) = Тип("ДокументСсылка.Событие") Тогда
		КонтактыСобытия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Предмет, Новый Структура("Контакт", "Участники.Контакт")).Контакт.Выгрузить();
		Если КонтактыСобытия.Количество() <> 0 Тогда
			Возврат КонтактыСобытия[0].Контакт;
		Иначе
			Возврат Справочники.Контрагенты.ПустаяСсылка();
		КонецЕсли;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция СоздатьEmail(Предмет, ДополнительныеПараметры)
	
	НовоеСобытие = НовыйДокументСобытие(Перечисления.ТипыСобытий.ЭлектронноеПисьмо, Предмет);
	НовоеСобытие.ЗаполнитьПоШаблону(ШаблонСообщения, Предмет, ДополнительныеПараметры);
	НовоеСобытие.УчетнаяЗапись = УчетнаяЗапись;
	ЗаполнитьУчастниковСобытия(НовоеСобытие, Предмет);
	НовоеСобытие.Записать();
	
	Возврат НовоеСобытие.Ссылка;
	
КонецФункции

Функция СоздатьSMS(Предмет, ДополнительныеПараметры)
	
	НовоеСобытие = НовыйДокументСобытие(Перечисления.ТипыСобытий.ЭлектронноеПисьмо, Предмет);
	НовоеСобытие.ЗаполнитьПоШаблону(ШаблонСообщения, Предмет, ДополнительныеПараметры);
	ЗаполнитьУчастниковСобытия(НовоеСобытие, Предмет);
	НовоеСобытие.Записать();
	
	Возврат НовоеСобытие.Ссылка;
	
КонецФункции

Процедура ОтправитьСобытие(СозданноеСобытие)
	
	Событие = СозданноеСобытие.ПолучитьОбъект();
	
	Если Событие.ТипСобытия <> Перечисления.ТипыСобытий.ЭлектронноеПисьмо
		И Событие.ТипСобытия <> Перечисления.ТипыСобытий.СообщениеSMS Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполненоКакСвязаться = ЗаполненоКакСвязатьсяВСобытии(Событие);
	ПолучательСообщения = АссистентУправления.ПолучитьОтветственного(СозданноеСобытие);
	
	Если НЕ ЗаполненоКакСвязаться Тогда
		ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
		ДанныеСообщения.Объект = СозданноеСобытие;
		ДанныеСообщения.Текст = НСтр("ru='Не удалось отправить сообщение, т.к. отсутствуют получатели'");
		ДанныеСообщения.Автор = АссистентУправления.ПользовательАссистент();
		ДанныеСообщения.Получатель = ПолучательСообщения;
		ОбсужденияУНФ.СоздатьСообщениеОтложенно(ДанныеСообщения);
		Возврат;
	КонецЕсли;
	
	СообщениеОтправлено = Истина;
	
	Попытка
		Если Событие.ТипСобытия = Перечисления.ТипыСобытий.ЭлектронноеПисьмо Тогда
			Событие.ОтправитьЭлектронноеПисьмо();
		ИначеЕсли Событие.ТипСобытия = Перечисления.ТипыСобытий.СообщениеSMS Тогда
			Событие.ОтправитьSMS();
		КонецЕсли;
	Исключение
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		СообщениеОтправлено = Ложь;
	КонецПопытки;
	
	Если СообщениеОтправлено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
	ДанныеСообщения.Объект = СозданноеСобытие;
	ДанныеСообщения.Текст = ТекстОшибки;
	ДанныеСообщения.Автор = АссистентУправления.ПользовательАссистент();
	ДанныеСообщения.Получатель = ПолучательСообщения;
	ОбсужденияУНФ.СоздатьСообщениеОтложенно(ДанныеСообщения);
	
КонецПроцедуры

Функция НовыйДокументСобытие(ТипСобытия, Основание)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ТипСобытия", ТипСобытия);
	ЗначенияЗаполнения.Вставить("ДокументОснование", Основание);
	
	НовоеСобытие = Документы.Событие.СоздатьДокумент();
	НовоеСобытие.ДополнительныеСвойства.Вставить("ЭтоЗаписьАссистентом", Истина);
	НовоеСобытие.Заполнить(ЗначенияЗаполнения);
	НовоеСобытие.Дата = ТекущаяДатаСеанса();
	
	Возврат НовоеСобытие;
	
КонецФункции

Процедура ЗаполнитьУчастниковСобытия(НовоеСобытие, Предмет)
	
	НовоеСобытие.Участники.Очистить();
	Контакт = КонтактИзПредмета(Предмет);
	
	Если НЕ ЗначениеЗаполнено(Контакт) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерКонтакт = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Контакт);
	Получатели = МенеджерКонтакт.ПолучателиЭлектронногоПисьма(Контакт);
	
	Если Получатели.Количество() = 0 Тогда
		НовыйУчастник = НовоеСобытие.Участники.Добавить();
		НовыйУчастник.Контакт = Контакт;
		Возврат;
	КонецЕсли;
	
	Для каждого Получатель Из Получатели Цикл
		НовыйУчастник = НовоеСобытие.Участники.Добавить();
		НовыйУчастник.Контакт = Получатель.Контакт;
		НовыйУчастник.КакСвязаться = Получатель.КакСвязаться;
	КонецЦикла;
	
КонецПроцедуры

Функция СообщениеРезультатАссистента(СозданноеСобытие)
	
	Если Идентификатор = Справочники.ЗадачиАссистентаПоНапоминаниямОЗаписи.ИдентификаторЗадачаНапоминаниеОЗаписи() Тогда
		СообщениеРезультатАссистента = НСтр("ru='Отправила покупателю напоминание о записи'");
	ИначеЕсли Идентификатор = Справочники.ЗадачиАссистентаПоНапоминаниямОЗаписи.ИдентификаторЗадачаПодтверждениеЗаписи() Тогда
		СообщениеРезультатАссистента = НСтр("ru='Отправила покупателю информацию о записи'");
	ИначеЕсли Идентификатор = Справочники.ЗадачиАссистентаПоНапоминаниямОЗаписи.ИдентификаторЗадачаПодтверждениеОтменыЗаписи() Тогда
		СообщениеРезультатАссистента = НСтр("ru='Отправила покупателю подтверждение отмены записи'");
	ИначеЕсли Идентификатор = Справочники.ЗадачиАссистентаПоНапоминаниямОЗаписи.ИдентификаторЗадачаПроведениеОпросаПослеЗаписи() Тогда
		СообщениеРезультатАссистента = НСтр("ru='Запросила у покупателя отзыв о посещении'");
	Иначе
		ТекстОшибки = СтрШаблон(НСтр("ru='Не определен текст сообщения ассистента для задачи ""%1""'"), Идентификатор);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Возврат СообщениеРезультатАссистента + Символы.ПС + ПолучитьНавигационнуюСсылку(СозданноеСобытие);
	
КонецФункции

Процедура ДобавитьСообщениеАссистентаПоРезультатуВыполненияВПредмет(Предмет, СозданноеСобытие)
	
	ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
	ДанныеСообщения.Объект = Предмет;
	ДанныеСообщения.Текст = СообщениеРезультатАссистента(СозданноеСобытие);
	ДанныеСообщения.Автор = АссистентУправления.ПользовательАссистент();
	ОбсужденияУНФ.СоздатьСообщениеОтложенно(ДанныеСообщения);
	
КонецПроцедуры

Функция ЗаполненоКакСвязатьсяВСобытии(Событие)
	
	Для каждого Участник Из Событие.Участники Цикл
		Если ЗначениеЗаполнено(Участник.КакСвязаться) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли